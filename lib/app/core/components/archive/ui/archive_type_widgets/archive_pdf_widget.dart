import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_error_widget.dart';
import 'package:aco_plus/app/core/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ArchivePDFWidget extends StatefulWidget {
  final ArchiveModel archive;
  final bool inList;
  const ArchivePDFWidget(this.archive, {required this.inList, super.key});

  @override
  State<ArchivePDFWidget> createState() => _ArchivePDFWidgetState();
}

class _ArchivePDFWidgetState extends State<ArchivePDFWidget> {
  PdfController? controller;
  bool hasError = false;

  @override
  void initState() {
    initController()
        .then((value) => setState(() {}))
        .catchError((e) => setState(() => hasError = true));
    super.initState();
  }

  Future<void> initController() async {
    if (widget.archive.bytes == null) {
      await widget.archive.fetchBytes();
    }
    controller = PdfController(
      document: PdfDocument.openData(widget.archive.bytes!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) return ArchiveErrorWidget(widget.archive);
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child:
          controller != null
              ? PdfView(controller: controller!)
              : const SizedBox(width: 20, height: 20, child: Loading()),
    );
  }
}
