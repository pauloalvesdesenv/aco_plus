import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color colorOpacity;
  final IconData icon;

  const NotificationWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.colorOpacity,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 16,
          right: 24,
          left: 24,
          bottom: 36,
        ),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const W(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppCss.smallBold.setColor(AppColors.black),
                  ),
                  Text(
                    subtitle,
                    style: AppCss.minimumRegular.setColor(
                      AppColors.neutralDark,
                    ),
                  ),
                ],
              ),
            ),
            const W(16),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => OverlaySupportEntry.of(context)!.dismiss(),
                child: Icon(
                  Icons.close,
                  color: AppColors.neutralMedium,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
