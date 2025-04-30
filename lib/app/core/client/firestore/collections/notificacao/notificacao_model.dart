import 'dart:convert';

import 'package:aco_plus/app/core/services/hash_service.dart';

class NotificacaoModel {
  final String id;
  final String title;
  final String description;
  bool viewed;
  final DateTime createdAt;
  final String userId;
  final String payload;

  NotificacaoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.viewed,
    required this.createdAt,
    required this.userId,
    required this.payload,
  });

  static NotificacaoModel empty() => NotificacaoModel(
      id: '',
      title: '',
      description: '',
      viewed: false,
      createdAt: DateTime.now(),
      userId: '',
      payload: '');

  NotificacaoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? viewed,
    DateTime? createdAt,
    String? userId,
    String? payload,
  }) {
    return NotificacaoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      viewed: viewed ?? this.viewed,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'viewed': viewed,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'payload': payload,
    };
  }

  factory NotificacaoModel.fromMap(Map<String, dynamic> map) {
    return NotificacaoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      viewed: map['viewed'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      userId: map['userId'] ?? '',
      payload: map['payload'] ?? '',
    );
  }
  factory NotificacaoModel.fromFCMMap(String userId, Map<String, dynamic> map) {
    return NotificacaoModel(
        id: HashService.get,
        title: map['message']['notification']['title'] ?? '',
        description: map['message']['notification']['body'] ?? '',
        viewed: false,
        createdAt: DateTime.now(),
        userId: userId,
        payload: jsonEncode(map['data']));
  }

  String toJson() => json.encode(toMap());

  factory NotificacaoModel.fromJson(String source) =>
      NotificacaoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificacaoModel(id: $id, title: $title, description: $description, viewed: $viewed, createdAt: $createdAt, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificacaoModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.viewed == viewed &&
        other.createdAt == createdAt &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        viewed.hashCode ^
        createdAt.hashCode ^
        userId.hashCode;
  }
}
