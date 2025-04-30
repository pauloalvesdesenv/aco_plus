import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:flutter/material.dart';

class ArchiveVideoWidget extends StatefulWidget {
  final ArchiveModel archive;
  const ArchiveVideoWidget(this.archive, {super.key});

  @override
  State<ArchiveVideoWidget> createState() => _ArchiveVideoWidgetState();
}

class _ArchiveVideoWidgetState extends State<ArchiveVideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (widget.archive.bytes != null
              ? MemoryImage(widget.archive.bytes!)
              : NetworkImage(widget.archive.url!)) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
