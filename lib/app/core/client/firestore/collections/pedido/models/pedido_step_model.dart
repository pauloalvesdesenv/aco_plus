import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class PedidoStepModel {
  final String id;
  final DateTime createdAt;
  StepModel step;

  PedidoStepModel({
    required this.id,
    required this.step,
    required this.createdAt,
  });

  factory PedidoStepModel.create(StepModel step) => PedidoStepModel(
    id: HashService.get,
    step: step,
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'step': step.id,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PedidoStepModel.fromMap(Map<String, dynamic> map) {
    return PedidoStepModel(
      id: map['id'],
      step: FirestoreClient.steps.getById(map['step']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoStepModel.fromJson(String source) =>
      PedidoStepModel.fromMap(json.decode(source));

  PedidoStepModel copyWith({String? id, StepModel? step, DateTime? createdAt}) {
    return PedidoStepModel(
      id: id ?? this.id,
      step: step ?? this.step,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
