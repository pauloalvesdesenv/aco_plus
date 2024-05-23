import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:flutter/widgets.dart';

class OrdemModel {
  final String id;
  final ProdutoModel produto;
  final DateTime createdAt;
  DateTime? endAt;
  List<PedidoProdutoModel> produtos;
  bool selected = true;

  double get qtdeTotal => produtos.fold(
      0, (previousValue, element) => previousValue + element.qtde);

  double quantideTotal() {
    return produtos.fold(
        0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeAguardando() {
    return produtos
        .where((e) =>
            e.statusView.status == PedidoProdutoStatus.aguardandoProducao)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdeProduzindo() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.produzindo)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
  }

  double qtdePronto() {
    return produtos
        .where((e) => e.statusess.last.status == PedidoProdutoStatus.pronto)
        .fold(0, (previousValue, element) => previousValue + element.qtde);
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

  OrdemModel({
    required this.id,
    required this.createdAt,
    required this.produto,
    required this.produtos,
    this.endAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'endAt': endAt?.millisecondsSinceEpoch,
      'produto': produto.toMap(),
      'idPedidosProdutos': produtos
          .map((x) => {'pedidoId': x.pedidoId, 'produtoId': x.id})
          .toList(),
    };
  }

  factory OrdemModel.fromMap(Map<String, dynamic> map) {
    List<PedidoProdutoModel> list = [];
    try {
      list = List<PedidoProdutoModel>.from(
        map['idPedidosProdutos']?.map((x) => FirestoreClient.pedidos
            .getProdutoByPedidoId(x['pedidoId'], x['produtoId'])),
      );
    } catch (_) {}
    return OrdemModel(
        id: map['id'] ?? '',
        produto: ProdutoModel.fromMap(map['produto']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        endAt: map['endAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['endAt'])
            : null,
        produtos: list);
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
  }) {
    return OrdemModel(
      id: id ?? this.id,
      produto: produto ?? this.produto,
      createdAt: createdAt ?? this.createdAt,
      endAt: endAt != null ? endAt() : this.endAt,
      produtos: produtos ?? this.produtos,
    );
  }
}
