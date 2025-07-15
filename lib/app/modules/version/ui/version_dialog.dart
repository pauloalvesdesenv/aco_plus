import 'dart:html' as html;

import 'package:aco_plus/app/core/client/firestore/collections/version/models/version_model.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<void> showVersionDialog(VersionModel version) async => await showDialog(
  context: contextGlobal,
  barrierDismissible: false,
  builder: (_) => VersionDialog(version),
);

class VersionDialog extends StatefulWidget {
  final VersionModel version;
  const VersionDialog(this.version, {super.key});

  @override
  State<VersionDialog> createState() => _VersionDialogState();
}

class _VersionDialogState extends State<VersionDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: const Text('Versão nova disponível'),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 340,
                child: TextButton(
                  onPressed: () {
                    if (kIsWeb) {
                      html.window.location.reload();
                    }
                  },
                  child: const Text('Atualizar'),
                ),
              ),
              Gap(8),
              Text(
                'Abra o site na guia anônima caso o botão não funcione.',
                style: AppCss.minimumRegular.setSize(12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
