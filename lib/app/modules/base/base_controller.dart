import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/http/fcm/fcm_provider.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

final baseCtrl = BaseController();

class BaseController {
  static final BaseController _instance = BaseController._();

  BaseController._();

  factory BaseController() => _instance;

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final AppStream<AppModule> moduleStream = AppStream<AppModule>();

  Future<void> onInit() async {
    moduleStream.add(
      usuario.role == UsuarioRole.operador
          ? AppModule.ordens
          : AppModule.values.first,
    );
    FCMProvider.putToken();
  }
}
