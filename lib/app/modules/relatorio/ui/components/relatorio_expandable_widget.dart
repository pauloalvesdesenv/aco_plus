import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class RelatorioExpandableWidget extends StatelessWidget {
  final String title;
  final String value;
  final List<Widget> children;
  final Color color;

  const RelatorioExpandableWidget({
    super.key,
    required this.title,
    required this.value,
    required this.children,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: color,
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[700]!),
      ),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[700]!)),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppCss.minimumRegular.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: AppCss.minimumRegular.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).add(const EdgeInsets.only(bottom: 16)),
      children: children,
    );
  }
}
