import 'package:aco_plus/app/core/components/custom_quill/custom_quill_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillViewer extends StatelessWidget {
  final QuillController controller;

  const CustomQuillViewer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      configurations: QuillEditorConfigurations(
        controller: controller,
        onLaunchUrl: (string) async {
          await launch(context, string);
        },
        builder: (context, rawEditor) {
          return rawEditor;
        },
        elementOptions: elementOptions,
        padding: const EdgeInsets.all(8),
        maxHeight: 200,
        minHeight: 30,
        readOnly: true,
        showCursor: false,
        customStyles: defaultStyles,
        isOnTapOutsideEnabled: true,
      ),
    );
  }
}
