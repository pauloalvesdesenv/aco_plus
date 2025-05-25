import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_step_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_tags_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_users_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class KanbanCardCalendarWidget extends StatefulWidget {
  final PedidoModel pedido;
  final CalendarFormat calendarFormat;
  const KanbanCardCalendarWidget(this.pedido, this.calendarFormat, {super.key});

  @override
  State<KanbanCardCalendarWidget> createState() =>
      _KanbanCardCalendarWidgetState();
}

class _KanbanCardCalendarWidgetState extends State<KanbanCardCalendarWidget> {
  KanbanCardStepViewMode stepViewMode = KanbanCardStepViewMode.collapsed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contrains) {
        bool isSM = contrains.maxWidth < 100;
        return InkWell(
          onTap: () => kanbanCtrl.setPedido(widget.pedido),
          child: MouseRegion(
            onEnter: (event) =>
                setState(() => stepViewMode = KanbanCardStepViewMode.expanded),
            onExit: (event) =>
                setState(() => stepViewMode = KanbanCardStepViewMode.collapsed),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.fromLTRB(0.03, 0.03, 0.03, 1),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.pedido.tags.isNotEmpty) ...[
                      KanbanCardTagsWidget(
                        pedido: widget.pedido,
                        viewMode:
                            stepViewMode == KanbanCardStepViewMode.expanded ||
                                widget.calendarFormat == CalendarFormat.week
                            ? WidgetViewMode.normal
                            : WidgetViewMode.minified,
                      ),
                      const H(4),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.pedido.localizador,
                            style: AppCss.minimumRegular.copyWith(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (!isSM)
                          if (widget.pedido.users.isNotEmpty)
                            KanbanCardUsersWidget(
                              widget.pedido,
                              viewMode:
                                  stepViewMode ==
                                          KanbanCardStepViewMode.expanded ||
                                      widget.calendarFormat ==
                                          CalendarFormat.week
                                  ? WidgetViewMode.normal
                                  : WidgetViewMode.minified,
                            ),
                      ],
                    ),
                    const H(4),
                    KanbanCardStepWidget(
                      widget.pedido.step,
                      viewMode: stepViewMode,
                      calendarFormat: widget.calendarFormat,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
