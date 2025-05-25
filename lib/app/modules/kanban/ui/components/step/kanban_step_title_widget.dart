import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/enums/sort_step_type.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:flutter/material.dart';

class KanbanStepTitleWidget extends StatelessWidget {
  final KanbanUtils utils;
  final StepModel step;
  final List<PedidoModel> pedidos;
  const KanbanStepTitleWidget(this.utils, this.step, this.pedidos, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: false,
      minTileHeight: 30,
      tilePadding: const EdgeInsets.only(left: 8),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: PopupMenuButton<SortStepType?>(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          fixedSize: WidgetStateProperty.all(const Size(10, 10)),
        ),
        padding: EdgeInsets.zero,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        onSelected: (e) => kanbanCtrl.onOrderPedidos(e, pedidos),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Ordenação',
                    style: AppCss.minimumBold.setSize(16),
                  ),
                ),
                const Icon(Icons.close, color: Colors.black, size: 16),
              ],
            ),
          ),
          ...SortStepType.values.map(
            (e) => PopupMenuItem(value: e, child: Text(e.label)),
          ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: Text(step.name, style: AppCss.minimumBold)),
                if (!step.isEnable)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    child: const Icon(Icons.lock, color: Colors.red, size: 12),
                  ),
              ],
            ),
          ),
          Text(
            pedidos
                .where((e) => utils.isPedidoVisibleFiltered(e))
                .map((e) => e.getQtdeTotal())
                .fold(.0, (a, b) => a + b)
                .toKg(),
            style: AppCss.minimumRegular,
          ),
        ],
      ),
      onExpansionChanged: (e) {},
      children: const <Widget>[],
    );
  }
}
