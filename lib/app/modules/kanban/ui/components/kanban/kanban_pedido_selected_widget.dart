import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KanbanPedidoSelectedWidget extends StatelessWidget {
  final KanbanUtils utils;
  const KanbanPedidoSelectedWidget(this.utils, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: utils.isPedidoSelected ? 1 : 0,
        child: !utils.isPedidoSelected
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.all(16),
                width: 800,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PedidoPage(
                    pedido: utils.pedido!,
                    reason: PedidoInitReason.kanban,
                    onDelete: () => kanbanCtrl.setPedido(null),
                  ),
                ),
              ));
  }
}
