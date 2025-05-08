import 'dart:convert';

import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter/material.dart';

enum PedidoProdutoStatus { separado, aguardandoProducao, produzindo, pronto }

List<PedidoProdutoStatus> pedidoProdutoStatusValues = PedidoProdutoStatus.values
    .sublist(1);

extension PedidoProdutoStatusExt on PedidoProdutoStatus {
  String get label {
    switch (this) {
      case PedidoProdutoStatus.separado:
        return 'Separado';
      case PedidoProdutoStatus.aguardandoProducao:
        return 'Aguardando Produção';
      case PedidoProdutoStatus.produzindo:
        return 'Produzindo';
      case PedidoProdutoStatus.pronto:
        return 'Pronto';
    }
  }

  Color get color {
    switch (this) {
      case PedidoProdutoStatus.separado:
        return Colors.grey;
      case PedidoProdutoStatus.aguardandoProducao:
        return Colors.red;
      case PedidoProdutoStatus.produzindo:
        return Colors.yellow;
      case PedidoProdutoStatus.pronto:
        return Colors.green;
    }
  }
}

class PedidoProdutoStatusModel {
  final String id;
  PedidoProdutoStatus status;
  final DateTime createdAt;

  factory PedidoProdutoStatusModel.empty() => PedidoProdutoStatusModel(
    createdAt: DateTime.now(),
    id: HashService.get,
    status: PedidoProdutoStatus.pronto,
  );

  PedidoProdutoStatus getStatusMinified() {
    if (status == PedidoProdutoStatus.separado) {
      return PedidoProdutoStatus.aguardandoProducao;
    }
    return status;
  }

  PedidoProdutoStatus getStatusView() {
    if (status == PedidoProdutoStatus.separado) {
      return PedidoProdutoStatus.aguardandoProducao;
    }
    return status;
  }

  PedidoProdutoStatusModel({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory PedidoProdutoStatusModel.create(PedidoProdutoStatus status) =>
      PedidoProdutoStatusModel(
        id: HashService.get,
        createdAt: DateTime.now(),
        status: status,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoProdutoStatusModel.fromMap(Map<String, dynamic> map) {
    return PedidoProdutoStatusModel(
      id: map['id'] ?? '',
      status: PedidoProdutoStatus.values[map['status']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoProdutoStatusModel.fromJson(String source) =>
      PedidoProdutoStatusModel.fromMap(json.decode(source));

  PedidoProdutoStatusModel copyWith({
    String? id,
    PedidoProdutoStatus? status,
    DateTime? createdAt,
  }) {
    return PedidoProdutoStatusModel(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
