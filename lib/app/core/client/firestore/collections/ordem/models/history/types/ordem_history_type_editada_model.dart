import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeEditadaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final MateriaPrimaModel? materiaPrima;
  final List<PedidoProdutoModel> adicionados;
  final List<PedidoProdutoModel> removidos;

  OrdemHistoryTypeEditadaModel({
    required this.user,
    required this.createdAt,
    required this.materiaPrima,
    required this.adicionados,
    required this.removidos,
  });

  factory OrdemHistoryTypeEditadaModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypeEditadaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      materiaPrima: MateriaPrimaModel.fromMap(json['materiaPrima']),
      adicionados: json['adicionados']
          .map((e) => PedidoProdutoModel.fromMap(e))
          .toList(),
      removidos: json['removidos']
          .map((e) => PedidoProdutoModel.fromMap(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'materiaPrima': materiaPrima?.toMap(),
    };
  }
}
