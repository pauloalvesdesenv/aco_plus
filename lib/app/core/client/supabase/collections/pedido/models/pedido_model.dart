import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';

class PedidoModel {
  final String id;
  final String localizador;
  final String descricao;
  final DateTime createdAt;
  final DateTime? deliveryAt;
  final ClienteModel cliente;
  final ObraModel obra;
  final List<PedidoProdutoModel> produtos;
  final PedidoTipo tipo;
  List<PedidoStatusModel> statusess;

  bool get isChangeStatusAvailable =>
      tipo == PedidoTipo.cda &&
      [
        PedidoStatus.aguardandoProducaoCDA,
        PedidoStatus.produzindoCDA,
        PedidoStatus.pronto
      ].contains(statusess.last.status);

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
        0, (previousValue, element) => previousValue + element.qtde);
  }

  double getQtdeAguardandoProducao() {
    return produtos
        .where((e) =>
            e.statusess.last.getStatusView() ==
            PedidoProdutoStatus.aguardandoProducao)
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
      'deliveryAt': deliveryAt?.millisecondsSinceEpoch,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
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
          map['status']?.map((x) => PedidoStatusModel.fromMap(x))),
      produtos: List<PedidoProdutoModel>.from(
          map['produtos']?.map((x) => PedidoProdutoModel.fromMap(x))),
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
  }) {
    return PedidoModel(
      id: id ?? this.id,
      localizador: localizador ?? this.localizador,
      descricao: descricao ?? this.descricao,
      createdAt: createdAt ?? this.createdAt,
      cliente: cliente ?? this.cliente,
      obra: obra ?? this.obra,
      produtos: produtos ?? this.produtos,
      tipo: tipo ?? this.tipo,
      statusess: statusess ?? this.statusess,
      deliveryAt: deliveryAt ?? this.deliveryAt,
    );
  }

  @override
  String toString() {
    return 'PedidoModel(id: id, localizador: $localizador, descricao: $descricao, createdAt: $createdAt, deliveryAt: $deliveryAt, cliente: $cliente, obra: $obra, produtos: $produtos, tipo: $tipo, statusess: $statusess)';
  }
}
