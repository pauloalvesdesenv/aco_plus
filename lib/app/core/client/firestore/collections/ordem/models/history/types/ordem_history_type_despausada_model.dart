import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeDespausadaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final String pedidoId;
  final String pedidoProdutoId;
  final String produtoId;
  final String ordemId;

  OrdemHistoryTypeDespausadaModel({
    required this.user,
    required this.createdAt,
    required this.pedidoId,
    required this.pedidoProdutoId,
    required this.produtoId,
    required this.ordemId,
  });

  factory OrdemHistoryTypeDespausadaModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypeDespausadaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      pedidoId: json['pedidoId'],
      pedidoProdutoId: json['pedidoProdutoId'],
      produtoId: json['produtoId'],
      ordemId: json['ordemId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'pedidoId': pedidoId,
      'pedidoProdutoId': pedidoProdutoId,
      'produtoId': produtoId,
      'ordemId': ordemId,
    };
  }
}
