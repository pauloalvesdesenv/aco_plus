import 'package:aco_plus/app/core/client/http/viacep/viacep_provider.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final enderecoCtrl = EnderecoController();

class EnderecoController {
  static final EnderecoController _instance = EnderecoController._();

  EnderecoController._();

  factory EnderecoController() => _instance;

  final AppStream<EnderecoCreateModel> enderecoCreateStream =
      AppStream<EnderecoCreateModel>();
  EnderecoCreateModel get form => enderecoCreateStream.value;

  void onInitEndereco(EnderecoModel? endereco) {
    enderecoCreateStream.add(endereco != null
        ? EnderecoCreateModel.edit(endereco)
        : EnderecoCreateModel());
  }

  List<EnderecoModel> getOrdensFiltered(
      String search, List<EnderecoModel> ordens) {
    if (search.length < 3) return ordens;
    List<EnderecoModel> filtered = [];
    for (final endereco in ordens) {
      if (endereco.toString().toCompare.contains(search.toCompare)) {
        filtered.add(endereco);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value) async {
    try {
      onValidEndereco();
      Navigator.pop(value, enderecoCreateStream.value.toEndereco());
      NotificationService.showPositive(
          'Endereco ${form.isEdit ? 'Editado' : 'Adicionado'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative(
        'Erro ao ${form.isEdit ? 'editar' : 'criar'} endereco',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  void onValidEndereco() {
    try {} catch (e) {
      NotificationService.showNegative(
        'Erro ao ${form.isEdit ? 'editar' : 'criar'} endereco',
        e.toString(),
        position: NotificationPosition.bottom,
      );
      rethrow;
    }
  }

  void onSearchCEP(String cep) async {
    final response = await ViacepProvider.getEndereco(cep);
    if (response != null) {
      final endereco = EnderecoCreateModel.fromViacep(response);

      enderecoCreateStream.add(endereco);
    } else {
      NotificationService.showNegative(
          'Erro na chamada', 'Nao foi possivel buscar endereço');
    }
  }
}
