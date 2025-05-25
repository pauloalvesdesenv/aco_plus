import 'package:aco_plus/app/app_controller.dart';
import 'package:aco_plus/app/app_widget.dart';
import 'package:aco_plus/app/core/router/flutter_web_plugins_shim.dart'
    if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_acompanhamento_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// if (dart.library.html) 'package:flutter_web_plugins/flutter_web_plugins.dart';

///acompanhamento/pedidos/aJo8pjTvyoplGQkmRjda8NT1H
class RouteConfig {
  static late RouterConfig<Object> config;
  static void setConfig() {
    usePathUrlStrategy();
    config = GoRouter(
      initialLocation: '/',
      navigatorKey: appCtrl.key,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/acompanhamento/pedidos/:id',
          pageBuilder: (context, state) => NoTransitionPage(
            child: PedidoAcompanhamentoPage(id: state.pathParameters['id']!),
          ),
        ),
      ],
    );
  }
}
