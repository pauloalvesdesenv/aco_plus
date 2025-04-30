import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

Future<bool> showLoadingDialog() async =>
    await showDialog<bool>(
      barrierDismissible: true,
      context: contextGlobal,
      builder: (_) => const LoadingDialog(),
    ) ??
    false;

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('Aviso', style: AppCss.largeBold),
      content: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primaryMain),
            ),
          ),
          const W(8),
          Text('Carregando...', style: AppCss.mediumRegular),
        ],
      ),
    );
  }
}
