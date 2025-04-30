import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/automatizacao_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';

final automatizacaoCtrl = AutomatizacaoController();

class AutomatizacaoController {
  static final AutomatizacaoController _instance = AutomatizacaoController._();

  AutomatizacaoController._();

  factory AutomatizacaoController() => _instance;

  Future<void> onSetStepByPedidoStatus(List<PedidoModel> pedidos) async {
    for (PedidoModel pedido in pedidos) {
      StepModel? step;
      switch (pedido.status) {
        case PedidoStatus.aguardandoProducaoCD:
          step = automatizacaoConfig.produtoPedidoSeparado.step;
          break;
        case PedidoStatus.produzindoCD:
          step = automatizacaoConfig.produzindoCDPedido.step;
          break;
        case PedidoStatus.aguardandoProducaoCDA:
          step = automatizacaoConfig.aguardandoArmacaoPedido.step;
          break;
        case PedidoStatus.produzindoCDA:
          step = automatizacaoConfig.produzindoArmacaoPedido.step;
          break;
        case PedidoStatus.pronto:
          switch (pedido.tipo) {
            case PedidoTipo.cd:
              step = automatizacaoConfig.prontoCDPedido.step;
              break;
            case PedidoTipo.cda:
              step = automatizacaoConfig.prontoArmacaoPedido.step;
            default:
          }

          break;
        default:
      }

      if (step != null) {
        if (pedido.step.index >= step.index) {
          step = null;
        }
      }

      if (step != null) {
        final stepById = FirestoreClient.steps.getById(step.id);
        pedido.steps.add(PedidoStepModel.create(stepById));
        pedidoCtrl.onAddHistory(
          pedido: pedido,
          data: stepById,
          type: PedidoHistoryType.step,
          action: PedidoHistoryAction.update,
          isFromAutomatizacao: true,
        );
        await FirestoreClient.pedidos.update(pedido);
      }
    }
  }
}
