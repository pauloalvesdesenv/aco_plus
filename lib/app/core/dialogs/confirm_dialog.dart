import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(String title, String message) async =>
    await showDialog<bool>(
      context: contextGlobal,
      builder: (_) => ConfirmDialog(title, message),
    ) ??
    false;

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  const ConfirmDialog(this.title, this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text(title, style: AppCss.largeBold),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(AppColors.primaryMain),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFebeaf3)),
          ),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(AppColors.primaryMain),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFebeaf3)),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
