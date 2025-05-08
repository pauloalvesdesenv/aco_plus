import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/graph/produto_status/produto_status_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final produtoStatusCtrl = ProdutoStatusController();

class ProdutoStatusController {
  static final ProdutoStatusController _instance = ProdutoStatusController._();

  ProdutoStatusController._();

  factory ProdutoStatusController() => _instance;

  List<ColumnSeries<ProdutoStatusGraphModel, String>> getSource() {
    return [
          PedidoProdutoStatus.aguardandoProducao,
          PedidoProdutoStatus.produzindo,
        ]
        .map(
          (status) => ColumnSeries<ProdutoStatusGraphModel, String>(
            dataSource: getSourceByStatus(status),
            name: status.label,
            xValueMapper:
                (ProdutoStatusGraphModel data, _) => data.produto.descricao,
            yValueMapper: (ProdutoStatusGraphModel data, _) => data.qtde,
            color: status.color,
            pointColorMapper:
                (ProdutoStatusGraphModel data, _) => data.status.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ),
        )
        .toList();
  }

  List<ProdutoStatusGraphModel> getSourceByStatus(PedidoProdutoStatus status) {
    final ordens =
        FirestoreClient.ordens.data.map((e) => e.copyWith()).toList();

    List<PedidoProdutoModel> pedidosProdutos = [];
    for (var ordem in ordens) {
      for (var produto in ordem.produtos) {
        if (produto.status.getStatusMinified() == status) {
          pedidosProdutos.add(produto.copyWith());
        }
      }
    }

    List<ProdutoStatusGraphModel> graph = [];
    for (ProdutoModel produto in FirestoreClient.produtos.data.map(
      (e) => e.copyWith(),
    )) {
      for (PedidoProdutoModel pedido in pedidosProdutos.where(
        (e) => e.produto.id == produto.id,
      )) {
        if (graph.any((e) => e.produto.id == produto.id)) {
          graph.firstWhere((e) => e.produto.id == produto.id).qtde +=
              pedido.qtde;
        } else {
          graph.add(
            ProdutoStatusGraphModel(
              status: pedido.status.getStatusMinified(),
              produto: produto,
              qtde: pedido.qtde,
            ),
          );
        }
      }
    }

    for (var produto in FirestoreClient.produtos.data.map(
      (e) => e.copyWith(),
    )) {
      if (!graph.map((e) => e.produto.id).contains(produto.id)) {
        graph.add(
          ProdutoStatusGraphModel(status: status, produto: produto, qtde: 0),
        );
      }
    }

    return graph;
  }
}
