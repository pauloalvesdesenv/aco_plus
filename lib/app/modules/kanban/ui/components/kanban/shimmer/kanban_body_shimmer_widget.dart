import 'package:aco_plus/app/core/components/app_shimmer.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/kanban_background_widget.dart';
import 'package:flutter/material.dart';

class KanbanBodyShimmerWidget extends StatelessWidget {
  const KanbanBodyShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return KanbanBackgroundWidget(
      child: Column(
        children: [
          const H(16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, i) => const W(16),
              itemBuilder: (_, i) => AppShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 300,
                  height: double.maxFinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
