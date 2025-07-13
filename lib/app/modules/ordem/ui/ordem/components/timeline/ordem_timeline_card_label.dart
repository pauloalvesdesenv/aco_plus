import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class OrdemTimelineCardLabel extends StatelessWidget {
  final String title;
  final String value;

  const OrdemTimelineCardLabel({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppCss.minimumRegular)),
        Text(value, style: AppCss.minimumRegular),
      ],
    );
  }
}
