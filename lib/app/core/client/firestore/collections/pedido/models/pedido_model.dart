import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/automatizacao_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/checklist/check_item_model.dart';
import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter/foundation.dart';

class PedidoModel {
  final String id;
  final String localizador;
  final String descricao;
  final DateTime createdAt;
  DateTime? deliveryAt;
  final ClienteModel cliente;
  final ObraModel obra;
  final List<PedidoProdutoModel> produtos;
  final PedidoTipo tipo;
  List<PedidoStatusModel> statusess;
  List<PedidoStepModel> steps;
  List<TagModel> tags;
  final List<ArchiveModel> archives;
  final List<CheckItemModel> checks;
  final String? checklistId;
  final List<CommentModel> comments;
  final List<UsuarioModel> users;
  final List<PedidoHistoryModel> histories;
  int index;
  final Key key = UniqueKey();
  bool isArchived = false;
  final String planilhamento;
  final String pedidoFinanceiro;
  final String instrucoesEntrega;
  final String instrucoesFinanceiras;

  factory PedidoModel.empty() => PedidoModel(
        id: HashService.get,
        localizador: 'NOTFOUND${HashService.get}',
        descricao: '',
        createdAt: DateTime.now(),
        deliveryAt: null,
        cliente: ClienteModel.empty(),
        obra: ObraModel.empty(),
        produtos: [],
        tipo: PedidoTipo.cda,
        statusess: [],
        steps: [],
        tags: [],
        checks: [],
        comments: [],
        users: [],
        index: 10000000,
        histories: [],
        isArchived: false,
        archives: [],
        checklistId: '',
        planilhamento: '',
        pedidoFinanceiro: '',
        instrucoesEntrega: '',
        instrucoesFinanceiras: '',
      );

  String get filtro => localizador + pedidoFinanceiro;

  StepModel get step => steps.last.step;
  PedidoStatus get status => statusess.last.status;

  bool get isChangeStatusAvailable =>
      !isAguardandoEntradaProducao() &&
      tipo == PedidoTipo.cda &&
      [
        PedidoStatus.aguardandoProducaoCDA,
        PedidoStatus.produzindoCDA,
        PedidoStatus.pronto,
      ].contains(status);

  void addStep(step) => steps.add(PedidoStepModel.create(step));

  bool isAguardandoEntradaProducao() {
    if (step.index >= automatizacaoConfig.produtoPedidoSeparado.step.index) {
      return false;
    }
    return true;
  }

  List<PedidoStatusModel> getArmacaoStatusses() {
    final statusessFiltered = <PedidoStatusModel>[];
    final status = statusess
        .where(
          (e) =>
              e.status == PedidoStatus.produzindoCD ||
              e.status == PedidoStatus.aguardandoProducaoCD,
        )
        .toList()
        .first;
    for (var status in statusess) {
      if (status.status != PedidoStatus.produzindoCD &&
          status.status != PedidoStatus.aguardandoProducaoCD) {
        statusessFiltered.add(status.copyWith());
      }
    }
    statusessFiltered.add(status.copyWith());
    statusessFiltered.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    for (var status in statusessFiltered) {
      if (status.status == PedidoStatus.produzindoCD) {
        status.status = PedidoStatus.aguardandoProducaoCD;
      }
    }
    return statusessFiltered;
  }

  int iOfProductById(String id) {
    return produtos.indexWhere((element) => element.id == id);
  }

  PedidoModel({
    required this.id,
    required this.localizador,
    required this.descricao,
    required this.createdAt,
    required this.deliveryAt,
    required this.cliente,
    required this.obra,
    required this.produtos,
    required this.tipo,
    required this.statusess,
    required this.steps,
    required this.tags,
    required this.checks,
    required this.comments,
    required this.users,
    required this.index,
    required this.histories,
    required this.isArchived,
    required this.archives,
    required this.checklistId,
    required this.planilhamento,
    required this.pedidoFinanceiro,
    required this.instrucoesEntrega,
    required this.instrucoesFinanceiras,
  });

  List<PedidoProdutoStatus> get getStatusess {
    List<PedidoProdutoStatus> statusess = [];
    for (var element in produtos) {
      statusess.add(element.statusess.last.status);
    }
    return statusess.toSet().toList();
  }

  double getQtdeTotal() {
    return produtos.fold(
      0,
      (previousValue, element) => previousValue + element.qtde,
    );
  }

  double getQtdeAguardandoProducao() {
    return produtos
        .where(
          (e) =>
              e.statusess.last.getStatusView() ==
              PedidoProdutoStatus.aguardandoProducao,
        )
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double getQtdeProduzindo() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.produzindo)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double getQtdePronto() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.pronto)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double getPrcntgAguardandoProducao() {
    final aguardandoProducao = getQtdeAguardandoProducao();
    final total = getQtdeTotal();
    if (total == 0) return 0;
    return aguardandoProducao / total;
  }

  double getPrcntgProduzindo() {
    final produzindo = getQtdeProduzindo();
    final total = getQtdeTotal();
    if (total == 0) return 0;
    return produzindo / total;
  }

  double getPrcntgPronto() {
    final pronto = getQtdePronto();
    final total = getQtdeTotal();
    if (total == 0) return 0;
    return pronto / total;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localizador': localizador,
      'descricao': descricao,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'cliente': cliente.toMap(),
      'obra': obra.toMap(),
      'produtos': produtos.map((x) => x.toMap()).toList(),
      'tipo': tipo.index,
      'status': statusess.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'tags': tags.map((x) => x.toMap()).toList(),
      'deliveryAt': deliveryAt?.millisecondsSinceEpoch,
      'archives': archives.map((x) => x.toMap()).toList(),
      'checks': checks.map((x) => x.toMap()).toList(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'users': users.map((x) => x.id).toList(),
      'index': index,
      'histories': histories.map((x) => x.toMap()).toList(),
      'isArchived': isArchived,
      'checklistId': checklistId,
      'planilhamento': planilhamento,
      'pedidoFinanceiro': pedidoFinanceiro,
      'instrucoesEntrega': instrucoesEntrega,
      'instrucoesFinanceiras': instrucoesFinanceiras,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      checklistId: map['checklistId'],
      localizador: map['localizador'] ?? '',
      descricao: map['descricao'] ?? '',
      id: map['id'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      deliveryAt: map['deliveryAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deliveryAt'])
          : null,
      cliente: ClienteModel.fromMap(map['cliente']),
      obra: ObraModel.fromMap(map['obra']),
      tipo: PedidoTipo.values[map['tipo']],
      statusess: List<PedidoStatusModel>.from(
        map['status']?.map((x) => PedidoStatusModel.fromMap(x)) ?? [],
      ),
      produtos: List<PedidoProdutoModel>.from(
        map['produtos']?.map((x) => PedidoProdutoModel.fromMap(x)) ?? [],
      ),
      archives: List<ArchiveModel>.from(
        map['archives']?.map((x) => ArchiveModel.fromMap(x)) ?? [],
      ),
      checks: List<CheckItemModel>.from(
        map['checks']?.map((x) => CheckItemModel.fromMap(x)) ?? [],
      ),
      comments: List<CommentModel>.from(
        map['comments']?.map((x) => CommentModel.fromMap(x)) ?? [],
      ),
      steps: map['steps'] != null && map['steps'].isNotEmpty
          ? List<PedidoStepModel>.from(
              map['steps']?.map((x) => PedidoStepModel.fromMap(x)),
            )
          : [
              PedidoStepModel(
                id: HashService.get,
                step: FirestoreClient.steps.data.first,
                createdAt: DateTime.now(),
              ),
            ],
      tags: map['tags'] != null
          ? List<TagModel>.from(
              map['tags']?.map((x) => TagModel.fromMap(x)),
            )
          : [],
      users: List<UsuarioModel>.from(
        map['users']?.map((x) => FirestoreClient.usuarios.getById(x)) ?? [],
      ),
      index: map['index'] ?? 0,
      histories: map['histories'] != null
          ? List<PedidoHistoryModel>.from(
              map['histories']?.map((x) => PedidoHistoryModel.fromMap(x)),
            )
          : [],
      isArchived: map['isArchived'] ?? false,
      planilhamento: map['planilhamento'] ?? '',
      pedidoFinanceiro: map['pedidoFinanceiro'] ?? '',
      instrucoesEntrega: map['instrucoesEntrega'] ?? '',
      instrucoesFinanceiras: map['instrucoesFinanceiras'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) =>
      PedidoModel.fromMap(json.decode(source));

  PedidoModel copyWith({
    String? id,
    String? localizador,
    String? descricao,
    DateTime? createdAt,
    ClienteModel? cliente,
    ObraModel? obra,
    List<PedidoProdutoModel>? produtos,
    PedidoTipo? tipo,
    List<PedidoStatusModel>? statusess,
    DateTime? deliveryAt,
    List<PedidoStepModel>? steps,
    List<TagModel>? tags,
    List<CheckItemModel>? checks,
    List<CommentModel>? comments,
    List<UsuarioModel>? users,
    int? index,
    List<PedidoHistoryModel>? histories,
    bool? isArchived,
    List<ArchiveModel>? archives,
    String? checklistId,
    String? planilhamento,
    String? pedidoFinanceiro,
    String? instrucoesEntrega,
    String? instrucoesFinanceiras,
  }) {
    return PedidoModel(
      id: id ?? this.id,
      checklistId: checklistId ?? this.checklistId,
      comments: comments ?? this.comments,
      checks: checks ?? this.checks,
      localizador: localizador ?? this.localizador,
      descricao: descricao ?? this.descricao,
      createdAt: createdAt ?? this.createdAt,
      cliente: cliente ?? this.cliente,
      obra: obra ?? this.obra,
      produtos: produtos ?? this.produtos,
      tipo: tipo ?? this.tipo,
      statusess: statusess ?? this.statusess,
      deliveryAt: deliveryAt ?? this.deliveryAt,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
      users: users ?? this.users,
      index: index ?? this.index,
      histories: histories ?? this.histories,
      isArchived: isArchived ?? this.isArchived,
      archives: archives ?? this.archives,
      planilhamento: planilhamento ?? this.planilhamento,
      pedidoFinanceiro: pedidoFinanceiro ?? this.pedidoFinanceiro,
      instrucoesEntrega: instrucoesEntrega ?? this.instrucoesEntrega,
      instrucoesFinanceiras:
          instrucoesFinanceiras ?? this.instrucoesFinanceiras,
    );
  }

  @override
  String toString() {
    return 'PedidoModel(id: id, localizador: $localizador, descricao: $descricao, createdAt: $createdAt, deliveryAt: $deliveryAt, cliente: $cliente, obra: $obra, produtos: $produtos, tipo: $tipo, statusess: $statusess, steps: $steps)';
  }
}
