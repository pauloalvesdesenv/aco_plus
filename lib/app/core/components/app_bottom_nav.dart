import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:flutter/material.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({super.key});

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  final List<AppModule> _modules = [AppModule.ordens, AppModule.materiaPrima];

  @override
  Widget build(BuildContext context) {
    return StreamOut<AppModule>(
      stream: baseCtrl.moduleStream.listen,
      builder: (_, module) => BottomNavigationBar(
        currentIndex: module == AppModule.ordens ? 0 : 1,
        onTap: (index) => baseCtrl.moduleStream.add(
          index == 0 ? AppModule.ordens : AppModule.materiaPrima,
        ),
        items: _modules
            .map(
              (module) => BottomNavigationBarItem(
                icon: Icon(module.icon),
                label: module.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
