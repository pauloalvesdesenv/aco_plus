import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_add_bottom.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class ArchivesWidget extends StatelessWidget {
  final String label;
  final List<ArchiveModel> archives;
  final void Function() onChanged;
  final String path;

  const ArchivesWidget({
    required this.path,
    required this.archives,
    required this.onChanged,
    this.label = 'Arquivos',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: AppCss.largeBold),
            const W(16),
            InkWell(
              onTap: () => onAdd(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        const H(16),
        if (archives.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nenhum arquivo adicionado',
                textAlign: TextAlign.start,
              ),
            ),
          ),
        if (archives.isNotEmpty)
          for (final archive in archives)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ArchiveWidget(
                archive,
                inList: true,
                onDelete: (e) async {
                  if (!await showConfirmDialog(
                    'Deseja excluir anexo?',
                    'Anexo não estará mais disponível',
                  )) {
                    return false;
                  }
                  archives.remove(e);
                  onChanged.call();
                },
              ),
            ),
      ],
    );
  }

  Future<void> onAdd() async {
    final archive = await showArchiveAddBottom(path);
    if (archive == null) return;
    archives.add(archive);
    onChanged.call();
  }
}
