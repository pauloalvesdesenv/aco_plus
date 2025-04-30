import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

Future<bool> showInfoDialog(String message) async =>
    await showDialog<bool>(
      context: contextGlobal,
      builder: (_) => InfoDialog(message),
    ) ??
    false;

class InfoDialog extends StatelessWidget {
  final String message;
  const InfoDialog(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('Aviso', style: AppCss.largeBold),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(AppColors.primaryMain),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFebeaf3)),
          ),
          child: const Text('Voltar'),
        ),
      ],
    );
  }
}
