import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeCriadaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final MateriaPrimaModel materiaPrima;

  OrdemHistoryTypeCriadaModel({
    required this.user,
    required this.createdAt,
    required this.materiaPrima,
  });

  factory OrdemHistoryTypeCriadaModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypeCriadaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      materiaPrima: MateriaPrimaModel.fromMap(json['materiaPrima']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'materiaPrima': materiaPrima.toMap(),
    };
  }
}
