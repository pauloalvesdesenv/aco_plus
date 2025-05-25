import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/firebase_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mime/mime.dart';

Future<ArchiveModel?> showArchiveAddBottom(String path) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => ArchiveAddBottom(path),
    );

class ArchiveAddBottom extends StatefulWidget {
  final String path;
  const ArchiveAddBottom(this.path, {super.key});

  @override
  State<ArchiveAddBottom> createState() => _ArchiveAddBottomState();
}

class _ArchiveAddBottomState extends State<ArchiveAddBottom> {
  ArchiveModel? archive;
  FilePickerResult? result;
  final TextController _nameEC = TextController();
  final TextController _descEC = TextController();
  final FocusNode _focusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) => KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (e) {
            if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.enter) {
              if (archive != null) {
                onConfirm();
              }
            }
          },
          child: Container(
            height: 390,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ListView(
              children: [
                const H(16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.all(16),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          AppColors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_backspace),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adicionar Arquivo', style: AppCss.largeBold),
                      const H(16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          archive != null ? _addedWidget() : _addWidget(),
                          const W(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppField(
                                  label: 'Nome',
                                  isDisable: true,
                                  controller: _nameEC,
                                ),
                                const H(16),
                                AppField(
                                  label: 'Descrição',
                                  controller: _descEC,
                                  onEditingComplete: () {
                                    if (archive != null) {
                                      onConfirm();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const H(16),
                      AppTextButton(
                        isEnable: archive != null,
                        label: 'Confirmar',
                        onPressed: () => onConfirm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _addedWidget() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ArchiveWidget(archive!, inList: false),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () {
              archive = null;
              _nameEC.text = '';
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryMain,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  InkWell _addWidget() {
    return InkWell(
      onTap: () => onAdd(),
      child: Container(
        width: 150,
        height: 180,
        padding: const EdgeInsets.all(58),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[400]!,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> onAdd() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result?.xFiles.isNotEmpty ?? false) {
      final xFile = result!.xFiles.first;
      final mime = lookupMimeType(kIsWeb ? xFile.name : xFile.path)!;
      archive = ArchiveModel.fromFile(
        bytes: await xFile.readAsBytes(),
        createdAt: DateTime.now(),
        name: xFile.name,
        mime: mime,
        type: mime.getArchiveTypeMimeType(),
      );
      _nameEC.text = xFile.name;
      _focusNode.requestFocus();
      setState(() {});
    }
  }

  Future<void> onConfirm() async {
    setState(() {
      isLoading = true;
    });
    final url = await FirebaseService.uploadFile(
      name: archive!.name!,
      bytes: await result!.xFiles.first.readAsBytes(),
      mimeType: archive!.mime,
      path: widget.path,
    );
    final archiveModel = ArchiveModel(
      url: url,
      name: archive!.name,
      createdAt: DateTime.now(),
      description: _descEC.text.isNotEmpty ? _descEC.text : null,
      type: archive!.type,
      mime: archive!.mime,
    );
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, archiveModel);
  }
}
