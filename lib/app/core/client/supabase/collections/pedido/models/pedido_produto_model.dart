import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';

class PedidoProdutoModel {
  final String id;
  final String pedidoId;
  final String clienteId;
  final String obraId;
  final ProdutoModel produto;
  final List<PedidoProdutoStatusModel> statusess;
  final double qtde;
  bool selected = true;
  

  PedidoModel get pedido => FirestoreClient.pedidos.getById(pedidoId);

  ClienteModel get cliente => FirestoreClient.clientes.getById(clienteId);
  ObraModel get obra => cliente.obras.firstWhere((e) => e.id == obraId);
  PedidoProdutoStatusModel get status => statusess.last;
  PedidoProdutoStatusModel get statusView => statusess.last.copyWith(
      status: statusess.last.status == PedidoProdutoStatus.separado
          ? PedidoProdutoStatus.aguardandoProducao
          : statusess.last.status);

  PedidoProdutoModel({
    required this.id,
    required this.pedidoId,
    required this.clienteId,
    required this.obraId,
    required this.produto,
    required this.statusess,
    required this.qtde,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'clienteId': clienteId,
      'obraId': obraId,
      'produto': produto.toMap(),
      'statusess': statusess.map((x) => x.toMap()).toList(),
      'qtde': qtde,
    };
  }

  factory PedidoProdutoModel.fromMap(Map<String, dynamic> map) {
    return PedidoProdutoModel(
      id: map['id'] ?? '',
      pedidoId: map['pedidoId'] ?? '',
      clienteId: map['clienteId'] ?? '',
      obraId: map['obraId'] ?? '',
      produto: ProdutoModel.fromMap(map['produto']),
      statusess: List<PedidoProdutoStatusModel>.from(
          map['statusess']?.map((x) => PedidoProdutoStatusModel.fromMap(x))),
      qtde: map['qtde'] != null ? double.parse(map['qtde'].toString()) : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoProdutoModel.fromJson(String source) =>
      PedidoProdutoModel.fromMap(json.decode(source));

  PedidoProdutoModel copyWith({
    String? id,
    String? pedidoId,
    String? clienteId,
    String? obraId,
    ProdutoModel? produto,
    List<PedidoProdutoStatusModel>? statusess,
    double? qtde,
  }) {
    return PedidoProdutoModel(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      clienteId: clienteId ?? this.clienteId,
      obraId: obraId ?? this.obraId,
      produto: produto ?? this.produto,
      statusess: statusess ?? this.statusess,
      qtde: qtde ?? this.qtde,
    );
  }
}
