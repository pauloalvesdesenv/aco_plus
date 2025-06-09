import 'package:aco_plus/app/core/models/service_model.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

AppController appCtrl = AppController();

class AppController {
  static final AppController _instance = AppController._();

  AppController._();

  factory AppController() => _instance;

  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  BuildContext get context => key.currentState!.context;

  bool isInitialized = false;
  Future<void> onInit() async {
    if (isInitialized) return;
    isInitialized = true;
    await Service.initAplicationServices();
    await usuarioCtrl.getCurrentUser();
    await kanbanCtrl.onInit();
    precacheImage(
      const AssetImage('assets/images/kanban_background.png'),
      context,
    );
  }
}
