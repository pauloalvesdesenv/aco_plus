import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? name;
  final String? url;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double radius;
  const AppAvatar({
    this.url,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.radius = 20,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.grey[300],
      radius: radius,
      child: getChild(),
    );
  }

  Widget getChild() {
    if (icon != null) {
      return Icon(icon, size: 16, color: foregroundColor);
    }
    if (url != null) {
      return Image.network(url!);
    }
    if (name != null) {
      return Text(name!.getInitials(), style: AppCss.mediumBold.setSize(12));
    }
    return const Icon(Icons.person, size: 16);
  }
}
