import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';

class OrdemHistoryTypeStatusOrdemModel extends OrdemHistoryDataModel {
  final UsuarioModel user;
  final DateTime createdAt;
  final PedidoProdutoStatus status;

  OrdemHistoryTypeStatusOrdemModel({
    required this.user,
    required this.createdAt,
    required this.status,
  });

  factory OrdemHistoryTypeStatusOrdemModel.fromJson(Map<String, dynamic> json) {
    return OrdemHistoryTypeStatusOrdemModel(
      user: UsuarioModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      status: PedidoProdutoStatus.values.byName(json['status']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
    };
  }
}
