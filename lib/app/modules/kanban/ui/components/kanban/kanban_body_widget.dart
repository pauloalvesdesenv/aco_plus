import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/calendar/kanban_calendar_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/calendar/kanban_day_selected_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_background_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_black_lens_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_pedido_selected_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/step/kanban_steps_widget.dart';
import 'package:flutter/material.dart';

class KanbanBodyWidget extends StatelessWidget {
  final KanbanUtils utils;
  const KanbanBodyWidget(this.utils, {super.key});

  @override
  Widget build(BuildContext context) {
    return KanbanBackgroundWidget(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child:
                    utils.view == KanbanViewMode.calendar
                        ? KanbanCalendarWidget(utils)
                        : KanbanStepsWidget(utils),
              ),
            ],
          ),
          KanbanBlackLensWidget(utils),
          KanbanDaySelectedWidget(utils),
          KanbanPedidoSelectedWidget(utils),
        ],
      ),
    );
  }
}
