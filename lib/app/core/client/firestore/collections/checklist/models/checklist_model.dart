import 'dart:convert';

import 'package:aco_plus/app/core/components/checklist/check_item_model.dart';
import 'package:flutter/foundation.dart';

class ChecklistModel {
  final String id;
  final String nome;
  final List<CheckItemModel> checklist;
  final DateTime createdAt;
  ChecklistModel({
    required this.id,
    required this.nome,
    required this.checklist,
    required this.createdAt,
  });

  ChecklistModel copyWith({
    String? id,
    String? nome,
    List<CheckItemModel>? checklist,
    DateTime? createdAt,
  }) {
    return ChecklistModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      checklist: checklist ?? this.checklist,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'checklist': checklist.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChecklistModel.fromMap(Map<String, dynamic> map) {
    return ChecklistModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      checklist: List<CheckItemModel>.from(
        map['checklist']?.map((x) => CheckItemModel.fromMap(x)),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistModel.fromJson(String source) =>
      ChecklistModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChecklistModel(id: $id, nome: $nome, checklist: $checklist, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChecklistModel &&
        other.id == id &&
        other.nome == nome &&
        listEquals(other.checklist, checklist) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        checklist.hashCode ^
        createdAt.hashCode;
  }
}
