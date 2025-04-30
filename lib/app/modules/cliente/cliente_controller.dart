import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/cliente_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final clienteCtrl = ClienteController();
ClienteModel get cliente => clienteCtrl.cliente!;

class ClienteController {
  static final ClienteController _instance = ClienteController._();

  ClienteController._();

  factory ClienteController() => _instance;

  final AppStream<ClienteModel?> clienteStream = AppStream<ClienteModel?>.seed(
    null,
  );
  ClienteModel? get cliente => clienteStream.value;

  final AppStream<ClienteUtils> utilsStream = AppStream<ClienteUtils>.seed(
    ClienteUtils(),
  );
  ClienteUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(ClienteUtils());
    FirestoreClient.clientes.fetch();
  }

  final AppStream<ClienteCreateModel> formStream =
      AppStream<ClienteCreateModel>();
  ClienteCreateModel get form => formStream.value;

  void init(ClienteModel? cliente) {
    formStream.add(
      cliente != null ? ClienteCreateModel.edit(cliente) : ClienteCreateModel(),
    );
  }

  List<ClienteModel> getClienteesFiltered(
    String search,
    List<ClienteModel> clientes,
  ) {
    if (search.length < 3) return clientes;
    List<ClienteModel> filtered = [];
    for (final cliente in clientes) {
      if (cliente.toString().toCompare.contains(search.toCompare)) {
        filtered.add(cliente);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, ClienteModel? cliente, bool isFromOrder) async {
    try {
      onValid(cliente);
      if (form.isEdit) {
        final edit = form.toClienteModel();
        await FirestoreClient.clientes.update(edit);
      } else {
        await FirestoreClient.clientes.add(form.toClienteModel());
      }
      if (isFromOrder) {
        Navigator.pop(value, form.isEdit ? cliente : null);
      } else {
        pop(value);
      }
      NotificationService.showPositive(
        'Cliente ${form.isEdit ? 'Editado' : 'Adicionado'}',
        'Operação realizada com sucesso',
        position: NotificationPosition.bottom,
      );
    } catch (e) {
      NotificationService.showNegative(
        'Erro',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onDelete(value, ClienteModel cliente) async {
    if (await _isDeleteUnavailable(cliente)) return;
    await FirestoreClient.clientes.delete(cliente);
    pop(value);
    NotificationService.showPositive(
      'Cliente Excluido',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<bool> _isDeleteUnavailable(ClienteModel cliente) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir o cliente?',
        deleteMessage: 'Todos seus dados serão apagados do sistema',
        infoMessage:
            'Não é possível exlcuir o cliente, pois ele está vinculado a um pedido.',
        conditional:
            FirestoreClient.pedidos.data.any((e) => e.cliente.id == cliente.id),
      );

  void onValid(ClienteModel? cliente) {
    if (form.isEdit) {
      if (cliente!.nome != form.nome.text) {
        if (FirestoreClient.clientes.data.any(
          (e) => e.nome == form.nome.text,
        )) {
          throw Exception('Já existe um cliente com esse nome');
        }
      }
      if (cliente.cpf != form.cpf.text) {
        if (form.cpf.text.isNotEmpty &&
            FirestoreClient.clientes.data.any((e) => e.cpf == form.cpf.text)) {
          throw Exception('Já existe um cliente com esse CPF/CNPJ');
        }
      }
    } else {
      if (FirestoreClient.clientes.data.any((e) => e.nome == form.nome.text)) {
        throw Exception('Já existe um cliente com esse nome');
      }
      if (form.cpf.text.isNotEmpty &&
          FirestoreClient.clientes.data.any((e) => e.cpf == form.cpf.text)) {
        throw Exception('Já existe um cliente com esse CPF/CNPJ');
      }
    }
    if (form.nome.text.length < 2) {
      throw Exception('Nome deve conter no mínimo 3 caracteres');
    }
  }
}
