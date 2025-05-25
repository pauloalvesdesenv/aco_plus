import 'package:flutter/material.dart';

class KanbanCardNotificacaoWidget extends StatefulWidget {
  const KanbanCardNotificacaoWidget({super.key});

  @override
  State<KanbanCardNotificacaoWidget> createState() =>
      _KanbanCardNotificacaoWidgetState();
}

class _KanbanCardNotificacaoWidgetState
    extends State<KanbanCardNotificacaoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.red.withOpacity(0.5),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.notifications, color: Colors.white, size: 10),
        );
      },
    );
  }
}
