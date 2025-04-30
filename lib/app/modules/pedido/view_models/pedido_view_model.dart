import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_create_by_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PedidoUtils {
  final TextController search = TextController();
  SortType sortType = SortType.localizator;
  SortOrder sortOrder = SortOrder.asc;
  List<StepModel> steps = [];
  bool showFilter = false;
}

class PedidoArquivedUtils {
  final TextController search = TextController();
  SortType sortType = SortType.localizator;
  SortOrder sortOrder = SortOrder.asc;
  List<StepModel> steps = [];
  bool showFilter = false;
}

class PedidoCreateModel {
  final String id;
  final TextController localizador = TextController();
  final TextController nome = TextController();
  final TextController descricao = TextController();
  final TextController clienteEC = TextController();
  ClienteModel? cliente;
  ClienteModel? clienteAdd;
  ObraModel? obra;
  PedidoTipo? tipo;
  PedidoProdutoCreateModel produto = PedidoProdutoCreateModel();
  final GlobalKey produtoKey = GlobalKey();
  List<PedidoProdutoCreateModel> produtos = [];
  DateTime? deliveryAt;
  ChecklistModel? checklist;
  StepModel? step;
  final TextController instrucoesEntrega = TextController();
  final TextController instrucoesFinanceiras = TextController();
  final TextController pedidoFinanceiro = TextController();
  final TextController planilhamento = TextController();

  late bool isEdit;

  PedidoCreateModel()
      : id = HashService.get,
        isEdit = false,
        step = FirestoreClient.steps.data.firstWhereOrNull(
          (e) =>
              e.id == FirestoreClient.automatizacao.data.criacaoPedido.step.id,
        );

  String getDetails() {
    List<String> localizador = [];
    localizador.add(
      this.localizador.text.isEmpty
          ? 'Localizador não informado'
          : this.localizador.text,
    );
    localizador.add(tipo?.label ?? 'Tipo não informado');
    localizador.add(
      descricao.text.isEmpty ? 'Descrição não informada' : descricao.text,
    );
    localizador.add(cliente?.nome ?? 'Cliente não informado');
    localizador.add(obra?.descricao ?? 'Obra não informada');
    localizador.add(
      deliveryAt == null ? 'Data de entrega não informada' : deliveryAt!.text(),
    );
    return localizador.join(' - ');
  }

  PedidoCreateModel.edit(PedidoModel pedido)
      : id = pedido.id,
        isEdit = true {
    localizador.text = pedido.localizador;
    descricao.text = pedido.descricao;
    cliente = FirestoreClient.clientes.getById(pedido.cliente.id);
    obra = cliente?.obras.firstWhereOrNull((e) => e.id == pedido.obra.id);
    tipo = pedido.tipo;
    produtos =
        pedido.produtos.map((e) => PedidoProdutoCreateModel.edit(e)).toList();
    deliveryAt = pedido.deliveryAt;
    step = FirestoreClient.steps.getById(pedido.steps.first.step.id);
    if (pedido.checklistId != null) {
      checklist = FirestoreClient.checklists.getById(pedido.checklistId!);
      if (checklist != null) {
        for (var item in checklist!.checklist) {
          final checkPedido = pedido.checks.firstWhereOrNull(
            (e) => e.title == item.title,
          );
          if (checkPedido != null) {
            item.isCheck = checkPedido.isCheck;
          }
        }
      }
    }
    checklist = pedido.checklistId != null
        ? FirestoreClient.checklists.getById(pedido.checklistId!)
        : null;
    instrucoesEntrega.text = pedido.instrucoesEntrega;
    instrucoesFinanceiras.text = pedido.instrucoesFinanceiras;
    pedidoFinanceiro.text = pedido.pedidoFinanceiro;
    planilhamento.text = pedido.planilhamento;
  }

  PedidoModel toPedidoModel(PedidoModel? pedido) {
    final pedidoStatusModel = PedidoStatusModel(
      id: HashService.get,
      status: PedidoStatus.produzindoCD,
      createdAt: pedido?.statusess.first.createdAt ?? DateTime.now(),
    );
    final pedidoStepModel = PedidoStepModel(
      id: id,
      step: step!,
      createdAt: DateTime.now(),
    );
    return PedidoModel(
      id: id,
      tipo: tipo!,
      descricao: descricao.text,
      statusess: [pedidoStatusModel],
      localizador: localizador.text,
      createdAt: pedido?.createdAt ?? DateTime.now(),
      cliente: cliente!,
      obra: obra!,
      produtos: produtos
          .map(
            (e) => e.toPedidoProdutoModel(id, cliente!, obra!).copyWith(),
          )
          .toList(),
      deliveryAt: deliveryAt,
      steps: pedido?.steps ?? [pedidoStepModel],
      tags: pedido?.tags ?? [tipo!.tag],
      checks: checklist?.checklist.map((e) => e.copyWith()).toList() ?? [],
      checklistId: checklist?.id,
      comments: pedido?.comments ?? [],
      users: pedido?.users ?? [],
      index: pedido?.index ?? 0,
      isArchived: pedido?.isArchived ?? false,
      archives: pedido?.archives ?? [],
      histories: pedido?.histories ??
          [
            PedidoHistoryModel(
              action: PedidoHistoryAction.create,
              createdAt: DateTime.now(),
              id: HashService.get,
              type: PedidoHistoryType.create,
              usuario: usuarioCtrl.usuario!,
              data: PedidoCreateByModel(
                name: usuarioCtrl.usuario?.nome ?? 'Nome Indisponível',
                date: DateTime.now(),
              ),
            ),
          ],
      instrucoesEntrega: instrucoesEntrega.text,
      instrucoesFinanceiras: instrucoesFinanceiras.text,
      pedidoFinanceiro: pedidoFinanceiro.text,
      planilhamento: planilhamento.text,
    );
  }
}
