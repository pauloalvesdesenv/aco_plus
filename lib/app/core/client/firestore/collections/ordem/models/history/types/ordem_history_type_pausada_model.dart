import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypePausadaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final String motivo;
  final String pedidoId;
  final String pedidoProdutoId;
  final String produtoId;
  final String ordemId;

  OrdemHistoryTypePausadaModel({
    required this.user,
    required this.createdAt,
    required this.motivo,
    required this.pedidoId,
    required this.pedidoProdutoId,
    required this.produtoId,
    required this.ordemId,
  });

  factory OrdemHistoryTypePausadaModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypePausadaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      motivo: json['motivo'],
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
      'motivo': motivo,
      'pedidoId': pedidoId,
      'pedidoProdutoId': pedidoProdutoId,
      'produtoId': produtoId,
      'ordemId': ordemId,
    };
  }
}
