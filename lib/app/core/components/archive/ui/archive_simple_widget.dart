import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/dialogs/loading_dialog.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/services/firebase_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ArchiveSimpleWidget extends StatefulWidget {
  final String label;
  final ArchiveModel? archive;
  final void Function(ArchiveModel? archive) onChanged;
  final String path;

  const ArchiveSimpleWidget({
    required this.path,
    required this.archive,
    required this.onChanged,
    this.label = 'Arquivos',
    super.key,
  });

  @override
  State<ArchiveSimpleWidget> createState() => _ArchiveSimpleWidgetState();
}

class _ArchiveSimpleWidgetState extends State<ArchiveSimpleWidget> {
  ArchiveModel? archive;
  XFile? result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppCss.largeBold),
        const H(16),
        widget.archive != null ? _addedWidget() : _addWidget(),
      ],
    );
  }

  Widget _addedWidget() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ArchiveWidget(widget.archive!, inList: false),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    widget.onChanged.call(null);
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  InkWell _addWidget() {
    return InkWell(
      onTap: () => onAdd(),
      child: Container(
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primaryMain,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Text(
                'Clique para\nfotografar',
                style: AppCss.smallRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onAdd() async {
    result = await ImagePicker().pickImage(source: ImageSource.camera);
    if (result != null) {
      showLoadingDialog();
      final mime = lookupMimeType(kIsWeb ? result!.name : result!.path)!;
      archive = ArchiveModel.fromFile(
        bytes: await result!.readAsBytes(),
        createdAt: DateTime.now(),
        name: result!.name,
        mime: mime,
        type: mime.getArchiveTypeMimeType(),
      );
      archive!.url = await FirebaseService.uploadFile(
        name: archive!.name!,
        bytes: await result!.readAsBytes(),
        mimeType: archive!.mime,
        path: widget.path,
      );
      widget.onChanged.call(archive);
      Navigator.pop(context);
    }
  }
}
