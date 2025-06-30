import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_materia_prima_produtos.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeMateriaPrimaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final OrdemMateriaPrimaProdutos materiaPrimaProdutos;

  OrdemHistoryTypeMateriaPrimaModel({
    required this.user,
    required this.createdAt,
    required this.materiaPrimaProdutos,
  });

  factory OrdemHistoryTypeMateriaPrimaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrdemHistoryTypeMateriaPrimaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      materiaPrimaProdutos: OrdemMateriaPrimaProdutos.fromJson(
        json['materiaPrimaProdutos'],
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'materiaPrimaProdutos': materiaPrimaProdutos.toJson(),
    };
  }
}
