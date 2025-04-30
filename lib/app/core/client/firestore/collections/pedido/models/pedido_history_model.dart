import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_archive_action_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_create_by_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/components/checklist/check_item_model.dart';
import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart' as user;
import 'package:flutter/material.dart';

enum PedidoHistoryType { status, step, comment, check, archive, create }

enum PedidoHistoryAction { create, update, delete }

extension PedidoHistoryTypeExtension on PedidoHistoryType {
  String get name {
    switch (this) {
      case PedidoHistoryType.status:
        return 'Status';
      case PedidoHistoryType.step:
        return 'Etapa';
      case PedidoHistoryType.comment:
        return 'Comentário';
      case PedidoHistoryType.check:
        return 'Checklist';
      case PedidoHistoryType.archive:
        return 'Arquivo';
      case PedidoHistoryType.create:
        return 'Criado';
    }
  }
}

extension PedidoHistoryActionExtension on PedidoHistoryAction {
  String get verb1 {
    switch (this) {
      case PedidoHistoryAction.create:
        return 'criado';
      case PedidoHistoryAction.update:
        return 'atualizado';
      case PedidoHistoryAction.delete:
        return 'excluido';
    }
  }

  String get verb2 {
    switch (this) {
      case PedidoHistoryAction.create:
        return 'criou';
      case PedidoHistoryAction.update:
        return 'atualizou';
      case PedidoHistoryAction.delete:
        return 'excluiu';
    }
  }
}

class PedidoHistoryModel {
  final String id;
  final PedidoHistoryType type;
  final UsuarioModel usuario;
  final DateTime createdAt;
  final PedidoHistoryAction action;
  final dynamic data;

  IconData get icon {
    switch (type) {
      case PedidoHistoryType.status:
        PedidoStatusModel status = data;
        return status.status.icon;
      case PedidoHistoryType.step:
        return Icons.move_down;
      case PedidoHistoryType.comment:
        return Icons.comment;
      case PedidoHistoryType.check:
        switch (action) {
          case PedidoHistoryAction.create:
            return Icons.add;
          case PedidoHistoryAction.update:
            return data.isCheck
                ? Icons.check_box
                : Icons.check_box_outline_blank;
          case PedidoHistoryAction.delete:
            return Icons.delete;
        }
      case PedidoHistoryType.archive:
        return Icons.archive;
      case PedidoHistoryType.create:
        return Icons.star;
    }
  }

  String get title {
    switch (type) {
      case PedidoHistoryType.status:
        return 'Status alterado';
      case PedidoHistoryType.step:
        return 'Etapa Alterada';
      case PedidoHistoryType.comment:
        return 'Comentário ${action.verb1}';
      case PedidoHistoryType.check:
        return 'Checklist ${action.verb1}';
      case PedidoHistoryType.archive:
        return 'Arquivo ${action.verb1}';
      case PedidoHistoryType.create:
        return 'Pedido Criado';
    }
  }

  String get description {
    switch (type) {
      case PedidoHistoryType.status:
        return 'Status alterado para ${(data.status as PedidoStatus).label}';
      case PedidoHistoryType.step:
        return '${usuario.nome} alterou a etapa\npara ${data.name}';
      case PedidoHistoryType.comment:
        return '${usuario.nome} ${action.verb2} um comentário';
      case PedidoHistoryType.check:
        switch (action) {
          case PedidoHistoryAction.create:
            return '${usuario.nome} criou o item ${data.title}';
          case PedidoHistoryAction.update:
            return '${usuario.nome} marcou o item ${data.title} como ${data.isCheck ? 'feito' : 'não feito'}';
          case PedidoHistoryAction.delete:
            return '${usuario.nome} deletou o item ${data.title}';
        }
      case PedidoHistoryType.archive:
        return '${usuario.nome} ${action.verb1} o pedido';
      case PedidoHistoryType.create:
        return '${usuario.nome} ${createdAt.textHour()}';
    }
  }

  PedidoHistoryModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.data,
    required this.usuario,
    required this.action,
  });

  PedidoHistoryModel.create({
    required this.data,
    required this.type,
    required this.action,
    bool isFromAutomatizacao = false,
  })  : id = HashService.get,
        createdAt = DateTime.now(),
        usuario = isFromAutomatizacao ? UsuarioModel.system : user.usuario;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'usuario': usuario.toMap(),
      'action': action.index,
      'data':
          data is StepModel ? (data as StepModel).toHistoryMap() : data.toMap(),
    };
  }

  factory PedidoHistoryModel.fromMap(Map<String, dynamic> map) {
    return PedidoHistoryModel(
      id: map['id'] ?? '',
      type: PedidoHistoryType.values[map['type']],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      data: toObject(PedidoHistoryType.values[map['type']], map['data']),
      usuario: UsuarioModel.fromMap(map['usuario']),
      action: PedidoHistoryAction.values[map['action']],
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoHistoryModel.fromJson(String source) =>
      PedidoHistoryModel.fromMap(json.decode(source));

  static dynamic toObject(PedidoHistoryType type, Map<String, dynamic> data) {
    switch (type) {
      case PedidoHistoryType.status:
        return PedidoStatusModel.fromMap(data);
      case PedidoHistoryType.step:
        return StepModel.fromMap(data, isHistory: true);
      case PedidoHistoryType.comment:
        return CommentModel.fromMap(data);
      case PedidoHistoryType.check:
        return CheckItemModel.fromMap(data);
      case PedidoHistoryType.archive:
        return PedidoArchiveActionModel.fromMap(data);
      case PedidoHistoryType.create:
        return PedidoCreateByModel.fromMap(data);
    }
  }
}
