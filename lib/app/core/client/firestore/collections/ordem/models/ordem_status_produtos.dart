import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';

class OrdemStatusProdutos {
  final PedidoProdutoStatus status;
  final List<PedidoProdutoModel> produtos;

  OrdemStatusProdutos({required this.status, required this.produtos});

  factory OrdemStatusProdutos.fromJson(Map<String, dynamic> json) {
    return OrdemStatusProdutos(
      status: PedidoProdutoStatus.values.byName(json['status']),
      produtos: List<PedidoProdutoModel>.from(
        (json['produtos'] ?? [])
            .map((e) => PedidoProdutoModel.fromMap(e))
            .toList(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'produtos': produtos.map((e) => e.toMap()).toList(),
    };
  }
}
