import 'dart:async';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_calendar_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_pedido_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class _HoverTimer {
  Timer? _timer;
  void start(
    VoidCallback onTimeout, {
    Duration duration = const Duration(seconds: 2),
  }) {
    cancel();
    _timer = Timer(duration, onTimeout);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer?.isActive ?? false;
}

class KanbanCardMouseRegionCalendarWidget extends StatefulWidget {
  final PedidoModel pedido;
  final CalendarFormat calendarFormat;
  final WidgetViewMode viewMode;
  const KanbanCardMouseRegionCalendarWidget(
    this.pedido, {
    this.viewMode = WidgetViewMode.normal,
    this.calendarFormat = CalendarFormat.month,
    super.key,
  });

  @override
  State<KanbanCardMouseRegionCalendarWidget> createState() =>
      _KanbanCardMouseRegionCalendarWidgetState();
}

class _KanbanCardMouseRegionCalendarWidgetState
    extends State<KanbanCardMouseRegionCalendarWidget> {
  late WidgetViewMode viewMode;
  final _HoverTimer _hoverTimer = _HoverTimer();

  @override
  void initState() {
    super.initState();
    viewMode = widget.viewMode;
  }

  @override
  void dispose() {
    _hoverTimer.cancel();
    super.dispose();
  }

  void _onMouseEnter() {
    _hoverTimer.start(() {
      if (mounted) {
        setState(() => viewMode = WidgetViewMode.expanded);
      }
    });
  }

  void _onMouseExit() {
    _hoverTimer.cancel();
    if (mounted) {
      setState(() => viewMode = widget.viewMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onMouseEnter(),
      onExit: (event) => _onMouseExit(),
      child: KanbanCardCalendarWidget(
        widget.pedido,
        widget.calendarFormat,
        viewMode: viewMode,
      ),
    );
  }
}
