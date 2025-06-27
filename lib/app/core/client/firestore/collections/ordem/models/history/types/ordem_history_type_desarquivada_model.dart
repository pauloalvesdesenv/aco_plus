import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeDesarquivadaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;

  OrdemHistoryTypeDesarquivadaModel({required this.user, required this.createdAt});

  factory OrdemHistoryTypeDesarquivadaModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypeDesarquivadaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
