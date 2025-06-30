import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';

class OrdemMateriaPrimaProdutos {
  final MateriaPrimaModel materiaPrima;
  final List<PedidoProdutoModel> produtos;

  OrdemMateriaPrimaProdutos({
    required this.materiaPrima,
    required this.produtos,
  });

  factory OrdemMateriaPrimaProdutos.fromJson(Map<String, dynamic> json) {
    return OrdemMateriaPrimaProdutos(
      materiaPrima: MateriaPrimaModel.fromMap(json['materiaPrima']),
      produtos: List<PedidoProdutoModel>.from(
        (json['produtos'] ?? []).map((e) => PedidoProdutoModel.fromMap(e)).toList(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materiaPrima': materiaPrima.toMap(),
      'produtos': produtos.map((e) => e.toMap()).toList(),
    };
  }
}
