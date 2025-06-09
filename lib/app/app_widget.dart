import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/router/route_config.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_theme.dart';
import 'package:aco_plus/app/modules/base/base_page.dart';
import 'package:aco_plus/app/modules/sign/ui/sign_up_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app_controller.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppController _appController = AppController();

  @override
  void initState() {
    _appController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: OverlaySupport(
        child: MaterialApp.router(
          color: AppColors.primaryMain,
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          title: 'AÇO+',
          routeInformationParser: RouteConfig.config.routeInformationParser,
          routeInformationProvider: RouteConfig.config.routeInformationProvider,
          routerDelegate: RouteConfig.config.routerDelegate,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamOutNull<UsuarioModel?>(
      stream: usuarioCtrl.usuarioStream.listen,
      loading: const Center(child: CircularProgressIndicator()),
      child: (_, data) =>
          data == null ? const SignUpPage() : const Portal(child: BasePage()),
    );
  }
}
