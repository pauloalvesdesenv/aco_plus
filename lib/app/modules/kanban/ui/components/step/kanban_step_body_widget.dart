import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';

class KanbanStepBodyWidget extends StatelessWidget {
  final KanbanUtils utils;
  final StepModel step;
  final List<PedidoModel> pedidos;
  const KanbanStepBodyWidget(this.utils, this.step, this.pedidos, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: step.isEnable
            ? Colors.grey[50]
            : Colors.red.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: RawScrollbar(
        trackColor: const Color(0xFFFAFAFA),
        thumbColor: Colors.grey.withValues(alpha: 0.7),
        crossAxisMargin: 2,
        interactive: true,
        radius: const Radius.circular(4),
        trackRadius: const Radius.circular(8),
        thickness: 8,
        controller: step.scrollController,
        trackVisibility: true,
        thumbVisibility: true,
        child: ListView(
          padding: const EdgeInsets.only(right: 2),
          physics: pedidos.isEmpty
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          controller: step.scrollController,
          cacheExtent: 200,
          children: [
            _dragTargetWidget(step, pedidos, 0),
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: SeparatedColumn(
                    separatorBuilder: (_, i) =>
                        utils.isPedidoVisibleFiltered(pedidos[i])
                            ? _dragTargetWidget(step, pedidos, i + 1)
                            : const SizedBox(),
                    children: pedidos
                        .map(
                          (e) => utils.isPedidoVisibleFiltered(e)
                              ? KanbanCardDraggableWidget(e)
                              : const SizedBox(),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            _dragTargetWidget(step, pedidos, pedidos.length, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _dragTargetWidget(
    StepModel step,
    List<PedidoModel> pedidos,
    int index, {
    bool isLast = false,
  }) =>
      DragTarget<PedidoModel>(
        onAcceptWithDetails: (details) =>
            kanbanCtrl.onAccept(step, details.data, index),
        builder: (context, candidateData, rejectedData) {
          bool isHover = candidateData.isNotEmpty;
          bool isEnable = step.isEnable;
          return AnimatedOpacity(
            opacity: isEnable && isHover ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.maxFinite,
              margin: isHover
                  ? EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: isLast ? 8 : 0,
                    )
                  : null,
              height: isHover || isLast ? 70 : 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      );
}
