import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/archive_type.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_image_widget.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_other_widget.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_pdf_widget.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_video_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/services/download_file_url_service/download_file_url_service.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class ArchiveWidget extends StatelessWidget {
  final ArchiveModel archive;
  final Function(ArchiveModel)? onDelete;
  final bool inList;
  const ArchiveWidget(
    this.archive, {
    required this.inList,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (inList) {
      return _itemRow(context);
    } else {
      return _itemWidget();
    }
  }

  Widget _itemRow(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            _itemWidget(),
            const W(16),
            Expanded(
              child: ListTile(
                title: Text(
                  archive.description ?? '',
                  style: AppCss.mediumBold,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H(4),
                    Text(
                      archive.name ?? '',
                      style: AppCss.mediumRegular.setSize(14),
                    ),
                    const H(4),
                    Text(
                      'Adicionado em ${archive.createdAt.textHour()}',
                      style: AppCss.mediumRegular.setSize(12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (onDelete != null)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
                minimumSize: WidgetStateProperty.all(Size.zero),
              ),
              icon: const Icon(Icons.delete, size: 14),
              onPressed: () => onDelete?.call(archive),
            ),
          ),
      ],
    );
  }

  Widget _itemWidget() {
    late Widget child;
    switch (archive.type) {
      case ArchiveType.image:
        child = ArchiveImageWidget(archive);
      case ArchiveType.video:
        child = ArchiveVideoWidget(archive);
      case ArchiveType.pdf:
        child = ArchivePDFWidget(archive, inList: inList);
      default:
        child = ArchiveOtherWidget(archive);
    }
    return InkWell(
      onTap: () => DownloadFileURLService.call(archive.url!),
      child: child,
    );
  }
}
