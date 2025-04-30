import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:flutter/material.dart';

class OrdemModel {
  final String id;
  final ProdutoModel produto;
  final DateTime createdAt;
  final MateriaPrimaModel? materiaPrima;
  DateTime? endAt;
  List<PedidoProdutoModel> produtos;
  bool selected = true;
  final OrdemFreezedModel freezed;
  bool isArchived;
  int? beltIndex;

  String get localizator => id.contains('_') ? id.split('_').first : id;

  List<PedidoModel> get pedidos {
    final pedidosIds =
        produtos.map((e) => e.pedido).map((e) => e.id).toSet().toList();
    return pedidosIds.map((e) => FirestoreClient.pedidos.getById(e)).toList();
  }

  double get qtdeTotal => produtos.isEmpty
      ? 0
      : produtos.fold(
          0, (previousValue, element) => previousValue + element.qtde);

  double quantideTotal() {
    return produtos.isEmpty
        ? 0
        : produtos.fold(
            0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeAguardando() {
    var where = produtos
        .where((e) =>
            e.statusView.status == PedidoProdutoStatus.aguardandoProducao)
        .toList();
    return where.isEmpty
        ? 0
        : where.fold(
            0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeProduzindo() {
    var where = produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.produzindo)
        .toList();
    return where.isEmpty
        ? 0
        : where.fold(
            0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdePronto() {
    var where = produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.pronto)
        .toList();
    return where.isEmpty
        ? 0
        : where.fold(
            0, (previousValue, element) => previousValue + element.qtde);
  }

  IconData get icon {
    if (freezed.isFreezed) return Icons.stop_circle_outlined;
    switch (status) {
      case PedidoProdutoStatus.aguardandoProducao:
        return Icons.access_time;
      case PedidoProdutoStatus.produzindo:
        return Icons.build_outlined;
      case PedidoProdutoStatus.pronto:
        return Icons.check;
      default:
        return Icons.error;
    }
  }

  //  double getPrcntgPronto() {
  //   final pronto = getQtdePronto();
  //   final total = getQtdeTotal();
  //   if (total == 0) return 0;
  //   return pronto / total;
  // }

  double getPrcntgAguardando() {
    final aguardando = qtdeAguardando();
    final total = quantideTotal();
    if (total == 0) return 0;
    return aguardando / total;
  }

  double getPrcntgProduzindo() {
    final produzindo = qtdeProduzindo();
    final total = quantideTotal();
    if (total == 0) return 0;
    return produzindo / total;
  }

  double getPrcntgPronto() {
    final pronto = qtdePronto();
    final total = quantideTotal();
    if (total == 0) return 0;
    return pronto / total;
  }

  PedidoProdutoStatus get status {
    if (pedidos.isEmpty) {
      return PedidoProdutoStatus.aguardandoProducao;
    }
    if (qtdePronto() == quantideTotal()) {
      return PedidoProdutoStatus.pronto;
    } else if (qtdeProduzindo() > 0) {
      return PedidoProdutoStatus.produzindo;
    } else {
      return PedidoProdutoStatus.aguardandoProducao;
    }
  }

  OrdemModel({
    required this.id,
    required this.createdAt,
    required this.produto,
    required this.produtos,
    required this.freezed,
    this.isArchived = false,
    this.materiaPrima,
    this.beltIndex,
    this.endAt,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'endAt': endAt?.millisecondsSinceEpoch,
      'produto': produto.toMap(),
      'idPedidosProdutos': produtos
          .map((x) => {'pedidoId': x.pedidoId, 'produtoId': x.id})
          .toList(),
      'freezed': freezed.toMap(),
      'beltIndex': beltIndex,
      'materiaPrima': materiaPrima?.toMap(),
      'isArchived': isArchived
    };
    return map;
  }

  factory OrdemModel.fromMap(Map<String, dynamic> map) {
    return OrdemModel(
        id: map['id'] ?? '',
        produto: ProdutoModel.fromMap(map['produto']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        endAt: map['endAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['endAt'])
            : null,
        produtos: List<PedidoProdutoModel>.from(
          map['idPedidosProdutos']?.map((x) => FirestoreClient.pedidos
              .getProdutoByPedidoId(x['pedidoId'], x['produtoId'])),
        ),
        freezed: map['freezed'] != null
            ? OrdemFreezedModel.fromMap(map['freezed'])
            : OrdemFreezedModel.static().copyWith(),
        beltIndex: map['beltIndex'],
        materiaPrima: map['materiaPrima'] != null
            ? MateriaPrimaModel.fromMap(map['materiaPrima'])
            : null,
        isArchived: map['isArchived'] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory OrdemModel.fromJson(String source) =>
      OrdemModel.fromMap(json.decode(source));

  OrdemModel copyWith({
    String? id,
    ProdutoModel? produto,
    DateTime? createdAt,
    ValueGetter<DateTime?>? endAt,
    List<PedidoProdutoModel>? produtos,
    OrdemFreezedModel? freezed,
  }) {
    return OrdemModel(
      id: id ?? this.id,
      produto: produto ?? this.produto,
      createdAt: createdAt ?? this.createdAt,
      endAt: endAt != null ? endAt() : this.endAt,
      produtos: produtos ?? this.produtos,
      freezed: freezed ?? this.freezed,
    );
  }
}

class OrdemFreezedModel {
  bool isFreezed = false;
  TextController reason;
  final DateTime updatedAt;

  static static() => OrdemFreezedModel(
      isFreezed: false, reason: TextController(), updatedAt: DateTime.now());

  OrdemFreezedModel({
    required this.isFreezed,
    required this.reason,
    required this.updatedAt,
  });

  OrdemFreezedModel copyWith({
    bool? isFreezed,
    TextController? reason,
    DateTime? updatedAt,
  }) {
    return OrdemFreezedModel(
      isFreezed: isFreezed ?? this.isFreezed,
      reason: reason ?? this.reason,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFreezed': isFreezed,
      'reason': reason.text,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrdemFreezedModel.fromMap(Map<String, dynamic> map) {
    return OrdemFreezedModel(
      isFreezed: map['isFreezed'] ?? false,
      reason: TextController(text: map['reason']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdemFreezedModel.fromJson(String source) =>
      OrdemFreezedModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OrdemFreezedModel(isFreezed: $isFreezed, reason: $reason)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrdemFreezedModel &&
        other.isFreezed == isFreezed &&
        other.reason == reason;
  }

  @override
  int get hashCode => isFreezed.hashCode ^ reason.hashCode;
}
