import 'package:aco_plus/app/core/components/app_shimmer.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:flutter/material.dart';

class KanbanTopBarShimmerWidget extends StatelessWidget {
  const KanbanTopBarShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => baseCtrl.key.currentState!.openDrawer(),
        icon: Icon(Icons.menu, color: AppColors.white),
      ),
      title: Text('Kanban', style: AppCss.largeBold.setColor(AppColors.white)),
      actions: [
        AppShimmer(child: Container(color: Colors.grey, width: 12, height: 12)),
        const W(32),
        AppShimmer(child: Container(color: Colors.grey, width: 12, height: 12)),
        const W(32),
        AppShimmer(child: Container(color: Colors.grey, width: 12, height: 12)),
        const W(12),
      ],
      backgroundColor: AppColors.primaryMain,
    );
  }
}
