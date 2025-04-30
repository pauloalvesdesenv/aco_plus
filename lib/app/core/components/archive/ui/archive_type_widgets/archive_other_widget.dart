import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:flutter/material.dart';

class ArchiveOtherWidget extends StatefulWidget {
  final ArchiveModel archive;
  const ArchiveOtherWidget(this.archive, {super.key});

  @override
  State<ArchiveOtherWidget> createState() => _ArchiveOtherWidgetState();
}

class _ArchiveOtherWidgetState extends State<ArchiveOtherWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200]!,
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Center(child: Icon(Icons.file_present_rounded)),
    );
  }
}
