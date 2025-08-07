import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AppBarcodeScannerPage extends StatefulWidget {
  const AppBarcodeScannerPage({super.key});

  @override
  State<AppBarcodeScannerPage> createState() => _AppBarcodeScannerPageState();
}

class _AppBarcodeScannerPageState extends State<AppBarcodeScannerPage> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Escanear código de barras',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (result) {
          if (result.barcodes.isNotEmpty) {
            if (result.barcodes.first.rawValue?.isNotEmpty ?? false) {
              if (!isScanned) {
                isScanned = true;
                Navigator.pop(context, result.barcodes.first.rawValue);
              }
            }
          }
        },
      ),
    );
  }
}
