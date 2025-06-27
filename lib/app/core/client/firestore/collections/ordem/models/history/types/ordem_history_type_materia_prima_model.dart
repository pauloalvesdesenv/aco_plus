import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeMateriaPrimaModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final Map<MateriaPrimaModel?, List<PedidoProdutoModel>> produtos;

  OrdemHistoryTypeMateriaPrimaModel({
    required this.user,
    required this.createdAt,
    required this.produtos,
  });

  factory OrdemHistoryTypeMateriaPrimaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrdemHistoryTypeMateriaPrimaModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      produtos: json['produtos']
          .map((e) => PedidoProdutoModel.fromMap(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'produtos': produtos.entries
          .map((e) => e.value.map((e) => e.toMap()).toList())
          .toList(),
    };
  }
}
