import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_type_widgets/archive_error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArchiveImageWidget extends StatefulWidget {
  final ArchiveModel archive;
  const ArchiveImageWidget(this.archive, {super.key});

  @override
  State<ArchiveImageWidget> createState() => _ArchiveImageWidgetState();
}

class _ArchiveImageWidgetState extends State<ArchiveImageWidget> {
  bool get hasBytes => widget.archive.bytes != null;
  @override
  Widget build(BuildContext context) {
    if (hasBytes) {
      return Container(
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Image.memory(
          widget.archive.bytes!,
          width: 150,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ArchiveErrorWidget(widget.archive),
        ),
      );
    }
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200]!,
        borderRadius: BorderRadius.circular(2),
      ),
      child: CachedNetworkImage(
        width: 150,
        height: 180,
        imageUrl: widget.archive.url!,
        placeholder:
            (_, __) => const SizedBox(
              width: 150,
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (_, __, ___) => ArchiveErrorWidget(widget.archive),
      ),
    );
  }
}
