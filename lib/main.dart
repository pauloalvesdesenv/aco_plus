import 'package:aco_plus/app/app_widget.dart';
import 'package:aco_plus/app/core/components/splash_page.dart';
import 'package:aco_plus/app/core/models/service_model.dart';
import 'package:aco_plus/app/core/router/route_config.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(const SplashPage());
  WidgetsFlutterBinding.ensureInitialized();
  setWebTitle('Aço+');
  RouteConfig.setConfig();
  await initializeDateFormatting('pt_BR');
  await Service.initAplicationServices();
  runApp(const App());
}
