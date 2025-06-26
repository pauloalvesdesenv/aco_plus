import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/calendar/kanban_calendar_builder_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/calendar/kanban_calendar_weekday_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:table_calendar/table_calendar.dart';

class KanbanCalendarWidget extends StatefulWidget {
  final KanbanUtils utils;
  final AutomatizacaoModel automatizacao;
  const KanbanCalendarWidget(this.utils, this.automatizacao, {super.key});

  @override
  State<KanbanCalendarWidget> createState() => _KanbanCalendarWidgetState();
}

class _KanbanCalendarWidgetState extends State<KanbanCalendarWidget> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    kanbanCtrl.onMountCalendar();
    super.initState();
  }

  DateTime getBorderDates({bool? first, bool? last}) {
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, 1);
    final dates = [
      ...widget.utils.calendar.keys.toList().map(
        (e) => DateFormat('dd/MM/yyyy').parse(e),
      ),
      nowDate,
    ];
    dates.sort();
    if (first == true) return dates.first.subtract(const Duration(days: 100));
    if (last == true) return dates.last.add(const Duration(days: 100));
    throw Exception('Invalid border date');
  }

  List<PedidoModel> getPedidos(DateTime day) {
    final key = DateFormat('dd/MM/yyyy').format(day);
    final pedidosByDay = widget.utils.calendar[key] ?? [];
    if (pedidosByDay.isEmpty) return [];
    final steps = widget.automatizacao.naoMostrarNoCalendario.steps!
        .map((e) => e.id)
        .toList();
    final pedidosByMostramNoCalendario = pedidosByDay
        .where((e) => !steps.contains(e.step.id))
        .toList();
    return pedidosByMostramNoCalendario;
  }

  DateTime getCurrentDay() {
    if (widget.utils.pedido != null) {
      if (widget.utils.pedido!.deliveryAt != null) {
        return widget.utils.pedido!.deliveryAt!;
      }
    }
    if (widget.utils.day != null) {
      return widget.utils.day!.keys.first;
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.white.withValues(alpha: 0.5),
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: [
              RawScrollbar(
                controller: _scrollController,
                trackColor: Colors.grey[700],
                thumbColor: Colors.grey[400],
                interactive: true,
                radius: const Radius.circular(4),
                thickness: 8,
                trackVisibility: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: TableCalendar(
                    key: UniqueKey(),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    firstDay: getBorderDates(first: true),
                    lastDay: getBorderDates(last: true),
                    focusedDay: kanbanCtrl.utils.focusedDay,
                    rowHeight:
                        widget.utils.calendarFormat == CalendarFormat.month
                        ? 170
                        : MediaQuery.of(context).size.height * 1.4,
                    daysOfWeekHeight: 30,
                    calendarFormat: widget.utils.calendarFormat,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      decoration: BoxDecoration(color: Colors.white60),
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(Icons.chevron_left),
                      rightChevronIcon: Icon(Icons.chevron_right),
                    ),
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) =>
                          KanbanCalendarWeekdayWidget(day),
                      defaultBuilder: (context, day, focusedDay) =>
                          KanbanCalendarBuilderWidget(
                            day: day,
                            pedidos: getPedidos(day),
                            backgroundColor: [6, 7].contains(day.weekday)
                                ? Colors.grey[200]!
                                : Colors.grey[50]!,
                            calendarFormat: widget.utils.calendarFormat,
                          ),
                      todayBuilder: (context, day, focusedDay) =>
                          KanbanCalendarBuilderWidget(
                            day: day,
                            pedidos: getPedidos(day),
                            backgroundColor: [6, 7].contains(day.weekday)
                                ? const Color(0xFFE3EFF5)
                                : const Color(0xFFE3EFF5),
                            calendarFormat: widget.utils.calendarFormat,
                          ),
                      outsideBuilder: (context, day, focusedDay) =>
                          widget.utils.calendarFormat == CalendarFormat.month
                          ? Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              color: Colors.grey.withValues(alpha: 0.9),
                            )
                          : KanbanCalendarBuilderWidget(
                              day: day,
                              pedidos: getPedidos(day),
                              backgroundColor: [6, 7].contains(day.weekday)
                                  ? Colors.grey[200]!
                                  : Colors.grey[50]!,
                              calendarFormat: widget.utils.calendarFormat,
                            ),
                      disabledBuilder: (context, day, focusedDay) =>
                          KanbanCalendarBuilderWidget(
                            day: day,
                            pedidos: getPedidos(day),
                            backgroundColor: const Color(0xFFE3EFF5),
                            calendarFormat: widget.utils.calendarFormat,
                          ),
                      weekNumberBuilder: (context, weekNumber) =>
                          const SizedBox(),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 22),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      kanbanCtrl.utils.calendarFormat =
                          widget.utils.calendarFormat == CalendarFormat.month
                          ? CalendarFormat.week
                          : CalendarFormat.month;
                      kanbanCtrl.utilsStream.update();
                    },
                    icon: Icon(
                      widget.utils.calendarFormat == CalendarFormat.month
                          ? Symbols.view_week
                          : Icons.calendar_month,
                    ),
                    label: Text(
                      widget.utils.calendarFormat == CalendarFormat.month
                          ? 'Semanal'
                          : 'Mensal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
