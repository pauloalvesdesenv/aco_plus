import 'dart:async';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_pedido_widget.dart';
import 'package:flutter/material.dart';

class _HoverTimer {
  Timer? _timer;
  void start(
    VoidCallback onTimeout, {
    Duration duration = const Duration(seconds: 3),
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

class KanbanCardMouseRegionWidget extends StatefulWidget {
  final PedidoModel pedido;
  final WidgetViewMode viewMode;
  const KanbanCardMouseRegionWidget(
    this.pedido, {
    this.viewMode = WidgetViewMode.normal,
    super.key,
  });

  @override
  State<KanbanCardMouseRegionWidget> createState() =>
      _KanbanCardMouseRegionWidgetState();
}

class _KanbanCardMouseRegionWidgetState
    extends State<KanbanCardMouseRegionWidget> {
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
      child: KanbanCardPedidoWidget(widget.pedido, viewMode: viewMode),
    );
  }
}
