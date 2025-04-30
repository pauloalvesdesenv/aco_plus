import 'package:flutter/material.dart';

class KanbanBackgroundWidget extends StatelessWidget {
  final Widget? child;
  const KanbanBackgroundWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/kanban_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
