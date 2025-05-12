import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/dialogs/loading_dialog.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart' as Navigator;
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/dashboard/dashboard_view_model.dart';

DashboardController dashCtrl = DashboardController();

class DashboardController {
  static final DashboardController _instance = DashboardController._();

  DashboardController._();

  factory DashboardController() => _instance;

  final AppStream<DashboardUtils> utilsStream = AppStream<DashboardUtils>.seed(
    DashboardUtils(),
  );
  DashboardUtils get utils => utilsStream.value;

  List<RankingModel<ClienteModel>> getRankingClientes() {
    List<RankingModel<ClienteModel>> rankings = [];
    for (ClienteModel transportadora in FirestoreClient.clientes.data) {
      final map = FirestoreClient.clientes.data.map(
        (e) => getClienteValueByType(e),
      );
      final num = (map.isNotEmpty ? map.reduce((a, b) => a + b) : 0).toDouble();
      rankings.add(
        RankingModel<ClienteModel>(
          model: transportadora,
          value: getTransportadoraFormatter(num),
        ),
      );
    }
    rankings.sort((a, b) => b.value.compareTo(a.value));
    return rankings.length > 10 ? rankings.sublist(0, 9) : rankings;
  }

  double getClienteValueByType(ClienteModel cliente) {
    switch (utils.clienteRankingType) {
      case DashboardClienteRankingType.pedidos:
        return 1;
      case DashboardClienteRankingType.kilos:
        return FirestoreClient.pedidos.data
            .where((e) => e.cliente.id == cliente.id)
            .map((e) => e.getQtdeTotal())
            .reduce((a, b) => a + b)
            .toDouble();
    }
  }

  String getTransportadoraFormatter(double value) {
    switch (utils.clienteRankingType) {
      case DashboardClienteRankingType.pedidos:
        return '${value.toInt()} un';
      case DashboardClienteRankingType.kilos:
        return value.toKg();
    }
  }

  Future<void> onReorderPrioridade(List<PedidoModel> pedidos) async {
    showLoadingDialog();
    await FirestoreClient.pedidos.updateAll(pedidos);
    // FirestoreClient.pedidos.fetch();
    Navigator.pop(contextGlobal);
    NotificationService.showPositive(
      'Pedidos reordenados.',
      'Operação realizada com sucesso.',
    );
  }
}
