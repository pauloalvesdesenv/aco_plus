import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/components/app_bottom_nav.dart';
import 'package:aco_plus/app/core/components/drawer/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    baseCtrl.onInit().then((_) {
      kanbanCtrl.onInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldKey: baseCtrl.key,
      drawer: const AppDrawer(),
      bottomNav: usuario.role == UsuarioRole.operador
          ? const AppBottomNav()
          : null,
      body: StreamOut(
        stream: baseCtrl.moduleStream.listen,
        builder: (_, __) => __.widget,
      ),
    );
  }
}
