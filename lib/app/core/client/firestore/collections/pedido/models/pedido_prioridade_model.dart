import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_prioridade_tipo.dart';

class PedidoPrioridadeModel {
  int index;
  final PedidoPrioridadeTipo tipo;
  final DateTime createdAt;

  PedidoPrioridadeModel({
    required this.index,
    required this.tipo,
    required this.createdAt,
  });

  String getLabel() {
    return '${index + 1}º ${tipo.getLabel()}';
  }

  String getLabelShort() {
    return '${index + 1}º ${tipo.getLabelShort()}';
  }

  factory PedidoPrioridadeModel.fromMap(Map<String, dynamic> map) {
    return PedidoPrioridadeModel(
      index: map['index'],
      tipo: PedidoPrioridadeTipo.values[map['tipo']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'tipo': tipo.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  PedidoPrioridadeModel copyWith({
    int? index,
    PedidoPrioridadeTipo? tipo,
    DateTime? createdAt,
  }) {
    return PedidoPrioridadeModel(
      index: index ?? this.index,
      tipo: tipo ?? this.tipo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
