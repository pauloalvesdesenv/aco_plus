import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_model.dart';

final graphOrdemTotalCtrl = GrahpOrdemTotalController();

class GrahpOrdemTotalController {
  static final GrahpOrdemTotalController _instance =
      GrahpOrdemTotalController._();

  GrahpOrdemTotalController._();

  factory GrahpOrdemTotalController() => _instance;

  final AppStream<GraphOrdemTotalModel> filterStream =
      AppStream<GraphOrdemTotalModel>.seed(GraphOrdemTotalModel());
  GraphOrdemTotalModel get filter => filterStream.value;

  List<GraphModel> getCirucularChart(GraphOrdemTotalModel filter) {
    List<OrdemModel> ordens =
        FirestoreClient.ordens.data
            .map(
              (o) => o.copyWith(
                produto: o.produto.copyWith(),
                produtos:
                    o.produtos
                        .map(
                          (p) => p.copyWith(
                            statusess:
                                p.statusess.map((s) => s.copyWith()).toList(),
                          ),
                        )
                        .toList(),
              ),
            )
            .toList()
            .where((e) => e.status != PedidoProdutoStatus.pronto)
            .toList();

    List<GraphModel> source = [];

    for (final status in PedidoProdutoStatus.values) {
      double volFinal = 0.0;
      double lengthFinal = 0.0;
      for (OrdemModel ordem in ordens) {
        final pedidos =
            ordem.produtos.where((p) => p.status.status == status).toList();
        double vol = pedidos.fold(.0, (a, b) => a + b.qtde);
        volFinal += vol;
        lengthFinal += pedidos.length;
      }
      if (volFinal > 0 && status != PedidoProdutoStatus.pronto) {
        source.add(
          GraphModel(
            vol: volFinal,
            label: status.label,
            length: lengthFinal,
            color: status.color,
          ),
        );
      }
    }

    return source;
  }
}
