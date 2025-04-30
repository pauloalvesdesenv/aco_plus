import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';

class AutomatizacaoItemModel {
  final AutomatizacaoItemType type;
  StepModel step;
  AutomatizacaoItemModel({required this.type, required this.step});

  AutomatizacaoItemModel copyWith({
    AutomatizacaoItemType? type,
    DateTime? createdAt,
    StepModel? step,
  }) {
    return AutomatizacaoItemModel(
      type: type ?? this.type,
      step: step ?? this.step,
    );
  }

  Map<String, dynamic> toMap() {
    return {'type': type.index, 'stepId': step.id};
  }

  factory AutomatizacaoItemModel.fromMap(Map<String, dynamic> map) {
    return AutomatizacaoItemModel(
      type: AutomatizacaoItemType.values[map['type']],
      step: FirestoreClient.steps.getById(map['stepId']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomatizacaoItemModel.fromJson(String source) =>
      AutomatizacaoItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AutomatizacaoItemModel(type: $type, step: $step)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutomatizacaoItemModel &&
        other.type == type &&
        other.step == step;
  }

  @override
  int get hashCode {
    return type.hashCode ^ step.hashCode;
  }
}
