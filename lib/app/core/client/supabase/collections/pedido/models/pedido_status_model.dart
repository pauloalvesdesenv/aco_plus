import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';

class PedidoStatusModel {
  final String id;
  PedidoStatus status;
  final DateTime createdAt;
  PedidoStatusModel({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoStatusModel.fromMap(Map<String, dynamic> map) {
    return PedidoStatusModel(
      id: map['id'],
      status: PedidoStatus.values[map['status']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoStatusModel.fromJson(String source) =>
      PedidoStatusModel.fromMap(json.decode(source));

  PedidoStatusModel copyWith({
    String? id,
    PedidoStatus? status,
    DateTime? createdAt,
  }) {
    return PedidoStatusModel(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
