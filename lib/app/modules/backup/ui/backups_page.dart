import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/services/download_file_url_service/download_file_url_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/backup/backup_controller.dart';
import 'package:aco_plus/app/modules/backup/backup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BackupsPage extends StatefulWidget {
  const BackupsPage({super.key});

  @override
  State<BackupsPage> createState() => _BackupsPageState();
}

class _BackupsPageState extends State<BackupsPage> {
  @override
  void initState() {
    setWebTitle('Backup');
    backupCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Backups',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => backupCtrl.onRestoreBackup(),
            icon: Icon(Icons.upload, color: AppColors.white),
          ),
          IconButton(
            onPressed: () => backupCtrl.onCreateBackup(),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<BackupModel>>(
        stream: backupCtrl.backupsStream.listen,
        builder: (_, backups) {
          backups = backups.reversed.toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Backups Realizados', style: AppCss.mediumBold),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: backups.length,
                  separatorBuilder: (_, i) => const Divisor(),
                  itemBuilder: (_, i) => _itemWidget(backups[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListTile _itemWidget(BackupModel backup) {
    return ListTile(
      onTap: () => DownloadFileURLService.call(backup.url),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(backup.nome, style: AppCss.mediumRegular),
      subtitle: Text(
        'Criado em ${DateFormat('dd/MM/yyyy HH:mm').format(backup.createdAt)}',
        style: AppCss.smallRegular.copyWith(color: Colors.grey[600]),
      ),
      trailing: Icon(
        Icons.file_download,
        size: 24,
        color: AppColors.neutralDark,
      ),
    );
  }
}
