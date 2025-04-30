import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_shipping_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class StepModel {
  final String id;
  final String name;
  final Color color;
  final List<UsuarioRole> moveRoles;
  final DateTime createdAt;
  final ScrollController scrollController = ScrollController();
  int index;
  List<String> fromStepsIds;
  bool isDefault = false;
  bool isShipping = false;
  StepShippingModel? shipping;
  bool isArchivedAvailable = false;
  bool isPermiteProducao = false;

  static StepModel notFound = StepModel(
      createdAt: DateTime.now(),
      fromStepsIds: [],
      isDefault: false,
      moveRoles: [],
      color: Colors.transparent,
      id: 'step-not-found',
      name: 'step-not-found',
      index: 100000000,
      isShipping: false,
      shipping: null,
      isArchivedAvailable: false,
      isPermiteProducao: false);

  List<StepModel> get fromSteps => fromStepsIds
      .map((e) => FirestoreClient.steps
          .getById(e)
          .copyWith(fromStepsIds: [], toStepsIds: []))
      .toList();

  bool get isEnable => moveRoles.contains(usuario.role);

  StepModel({
    required this.id,
    required this.name,
    required this.color,
    required this.fromStepsIds,
    required this.moveRoles,
    required this.createdAt,
    required this.index,
    required this.isDefault,
    required this.isShipping,
    required this.shipping,
    required this.isArchivedAvailable,
    required this.isPermiteProducao,
  });

  StepModel copyWith(
      {String? id,
      String? name,
      Color? color,
      List<String>? fromStepsIds,
      List<String>? toStepsIds,
      List<UsuarioRole>? moveRoles,
      DateTime? createdAt,
      int? index,
      bool? isDefault,
      bool? isShipping,
      StepShippingModel? shipping,
      bool? isArchivedAvailable,
      bool? isPermiteProducao}) {
    return StepModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      fromStepsIds: fromStepsIds ?? this.fromStepsIds,
      moveRoles: moveRoles ?? this.moveRoles,
      createdAt: createdAt ?? this.createdAt,
      index: index ?? this.index,
      isDefault: isDefault ?? this.isDefault,
      isShipping: isShipping ?? this.isShipping,
      shipping: shipping ?? this.shipping,
      isArchivedAvailable: isArchivedAvailable ?? this.isArchivedAvailable,
      isPermiteProducao: isPermiteProducao ?? this.isPermiteProducao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'fromStepsIds': fromStepsIds,
      'moveRoles': moveRoles.map((x) => x.index).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'index': index,
      'isDefault': isDefault,
      'isShipping': isShipping,
      'shipping': shipping?.toMap(),
      'isArchivedAvailable': isArchivedAvailable,
      'isPermiteProducao': isPermiteProducao,
    };
  }

  Map<String, dynamic> toHistoryMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'isShipping': isShipping,
      'shipping': shipping?.toMap(),
    };
  }

  factory StepModel.fromMap(Map<String, dynamic> map,
      {bool isHistory = false}) {
    if (isHistory) {
      return StepModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        index: 0,
        color: Colors.tealAccent,
        fromStepsIds: <String>[],
        moveRoles: <UsuarioRole>[],
        createdAt: DateTime.now(),
        isDefault: false,
        isShipping: map['isShipping'] ?? false,
        shipping: map['shipping'] != null
            ? StepShippingModel.fromMap(map['shipping'])
            : null,
        isArchivedAvailable: false,
        isPermiteProducao: false,
      );
    }
    return StepModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      index: map['index'] ?? 0,
      color: Color(map['color']),
      fromStepsIds: map['fromStepsIds'] != null
          ? List<String>.from(map['fromStepsIds'])
          : <String>[],
      moveRoles: List<UsuarioRole>.from(
          map['moveRoles']?.map((x) => UsuarioRole.values[x])),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isDefault: map['isDefault'] ?? false,
      isShipping: map['isShipping'] ?? false,
      shipping: map['shipping'] != null
          ? StepShippingModel.fromMap(map['shipping'])
          : null,
      isArchivedAvailable: map['isArchivedAvailable'] ?? false,
      isPermiteProducao: map['isPermiteProducao'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory StepModel.fromJson(String source) =>
      StepModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StepModel(id: $id, name: $name, color: $color, fromSteps: $fromSteps, moveRoles: $moveRoles, createdAt: $createdAt, index: $index, isDefault: $isDefault, isShipping: $isShipping, shipping: $shipping, isArchivedAvailable: $isArchivedAvailable)';
  }
}
