import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_mouse_region_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:separated_column/separated_column.dart';
import 'package:table_calendar/table_calendar.dart';

class KanbanCalendarBuilderWidget extends StatefulWidget {
  const KanbanCalendarBuilderWidget({
    super.key,
    required this.day,
    required this.pedidos,
    required this.backgroundColor,
    required this.calendarFormat,
    required this.utils,
  });

  final DateTime day;
  final List<PedidoModel> pedidos;
  final Color backgroundColor;
  final CalendarFormat calendarFormat;
  final KanbanUtils utils;
  @override
  State<KanbanCalendarBuilderWidget> createState() =>
      _KanbanCalendarBuilderWidgetState();
}

class _KanbanCalendarBuilderWidgetState
    extends State<KanbanCalendarBuilderWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border.all(
          color: const Color.fromARGB(
            255,
            209,
            210,
            214,
          ).withValues(alpha: 0.8),
          width: 0.25,
        ),
      ),
      width: double.maxFinite,
      child: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          physics: widget.pedidos.isEmpty
              ? const NeverScrollableScrollPhysics()
              : null,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat('d').format(widget.day),
                    style: AppCss.minimumRegular.copyWith(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ),
                if (widget.pedidos.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () =>
                          kanbanCtrl.setDay({widget.day: widget.pedidos}),
                      child: Icon(
                        Icons.fullscreen,
                        size: 16,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
              ],
            ),
            const H(8),
            if (widget.pedidos.isNotEmpty)
              SeparatedColumn(
                separatorBuilder: (_, __) => const H(8),
                children: widget.pedidos
                    .map(
                      (e) => widget.utils.isPedidoVisibleFiltered(e) ? KanbanCardMouseRegionCalendarWidget(
                              e,
                              calendarFormat: widget.calendarFormat,
                            )
                          : const SizedBox(),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
