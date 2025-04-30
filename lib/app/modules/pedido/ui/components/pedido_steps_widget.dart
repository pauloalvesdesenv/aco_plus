import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoStepsWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoStepsWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Text('Etapa', style: AppCss.largeBold)),
          if (pedido.steps.length > 1)
            InkWell(
              onTap: () => kanbanCtrl.onUndoStep(pedido),
              child: const Icon(Icons.swipe_left_alt_sharp),
            ),
          const W(8),
          InkWell(
            onTap: () => pedidoCtrl.onChangePedidoStep(pedido),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: pedido.step.color.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                pedido.step.name,
                style: AppCss.mediumRegular.setSize(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
