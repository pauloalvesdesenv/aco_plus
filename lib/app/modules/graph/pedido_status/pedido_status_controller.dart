import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
import 'package:aco_plus/app/modules/graph/pedido_status/pedido_status_model.dart';

final pedidoStatusCtrl = PedidoStatusController();

class PedidoStatusController {
  static final PedidoStatusController _instance = PedidoStatusController._();

  PedidoStatusController._();

  factory PedidoStatusController() => _instance;

  final AppStream<PedidoStatusGraphModel> filterStream =
      AppStream<PedidoStatusGraphModel>.seed(PedidoStatusGraphModel());
  PedidoStatusGraphModel get filter => filterStream.value;

  // PEDIDOS QUE ENTRARAM QUE COMEÇARAM A PRODUÇÃO HOJE
  // PEDIDOS QUE FORAM FINALIZADOS HOJE
  List<GraphModel> getCartesianChart(
    PedidoStatusGraphModel filter,
  ) {
    List<PedidoModel> pedidos = FirestoreClient.pedidos.data
        .map((e) =>
            e.copyWith(produtos: e.produtos.map((e) => e.copyWith()).toList()))
        .toList()
        .where((pedido) => pedido.status != PedidoStatus.pronto)
        .toList();

    List<GraphModel> source = [];

    for (var status in PedidoStatus.values) {
      double volFinal = 0.0;
      double lengthFinal = 0.0;
      for (PedidoModel pedido
          in pedidos.where((e) => e.status == status).toList()) {
        volFinal += pedido.produtos.fold(.0, (a, b) => a + b.qtde);
        lengthFinal++;
      }
      if (volFinal > 0) {
        source.add(GraphModel(
            vol: volFinal,
            label: status.label,
            length: lengthFinal,
            color: status.color));
      }
    }
    return source;
  }
}
