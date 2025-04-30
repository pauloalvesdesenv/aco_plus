import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/backup/backup_controller.dart';
import 'package:flutter/material.dart';

Future<void> showBackupRestoreDialog() async {
  showDialog(
    context: contextGlobal,
    builder: (_) => const BackupRestoreDialog(),
  );
}

class BackupRestoreDialog extends StatelessWidget {
  const BackupRestoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: backupCtrl.utilsStream.listen,
      builder:
          (_, utils) => SimpleDialog(
            title: const Column(
              children: [
                Text('Restaurando backup...'),
                Text(
                  'Não feche o aplicativo enquanto o processo estiver em andamento.',
                ),
              ],
            ),
            children: [
              Row(
                children: [
                  Text(utils.restoreTitle),
                  const Spacer(),
                  Text('${utils.restoreIndex}/${utils.restoreLenght}'),
                ],
              ),
              SizedBox(
                width: double.maxFinite,
                child: LinearProgressIndicator(
                  value: utils.restoreIndex / utils.restoreLenght,
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
