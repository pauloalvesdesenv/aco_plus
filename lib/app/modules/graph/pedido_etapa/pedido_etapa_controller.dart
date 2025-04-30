import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
import 'package:aco_plus/app/modules/graph/pedido_etapa/pedido_etapa_model.dart';

final pedidoEtapaCtrl = PedidoEtapaController();

class PedidoEtapaController {
  static final PedidoEtapaController _instance = PedidoEtapaController._();

  PedidoEtapaController._();

  factory PedidoEtapaController() => _instance;

  final AppStream<PedidoEtapaGraphModel> filterStream =
      AppStream<PedidoEtapaGraphModel>.seed(PedidoEtapaGraphModel());
  PedidoEtapaGraphModel get filter => filterStream.value;

  // PEDIDOS QUE ENTRARAM QUE COMEÇARAM A PRODUÇÃO HOJE
  // PEDIDOS QUE FORAM FINALIZADOS HOJE
  List<GraphModel> getCartesianChart(
    PedidoEtapaGraphModel filter,
  ) {
    List<PedidoModel> pedidos = FirestoreClient.pedidos.data
        .map((e) =>
            e.copyWith(produtos: e.produtos.map((e) => e.copyWith()).toList()))
        .toList();

    List<GraphModel> source = [];

    for (var step in FirestoreClient.steps.data) {
      double volFinal = 0.0;
      double lengthFinal = 0.0;
      for (PedidoModel pedido
          in pedidos.where((e) => e.step.id == step.id).toList()) {
        volFinal += pedido.produtos.fold(.0, (a, b) => a + b.qtde);
        lengthFinal++;
      }
      if (volFinal > 0) {
        source.add(
          GraphModel(
            vol: volFinal,
            label: step.name,
            length: lengthFinal,
            color: step.color,
          ),
        );
      }
    }

    return source;
  }
}
