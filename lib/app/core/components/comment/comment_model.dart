import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class CommentModel {
  final UsuarioModel user;
  final String delta;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reaction;
  final List<UsuarioModel> mentioneds;
  final List<CommentModel> respostas;
  CommentModel({
    required this.user,
    required this.delta,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
    required this.respostas,
    required this.mentioneds,
    this.reaction,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'text': delta,
      'isEdited': isEdited,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'reaction': reaction,
      'respostas': respostas.map((x) => x.toMap()).toList(),
      'mentioneds': mentioneds.map((x) => x.toMap()).toList(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      user: UsuarioModel.fromMap(map['user']),
      delta: map['text'] ?? '',
      isEdited: map['isEdited'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      reaction: map['reaction'] ?? '',
      respostas: List<CommentModel>.from(
        map['respostas']?.map((x) => CommentModel.fromMap(x)),
      ),
      mentioneds: List<UsuarioModel>.from(
        map['mentioneds']?.map((x) => UsuarioModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
