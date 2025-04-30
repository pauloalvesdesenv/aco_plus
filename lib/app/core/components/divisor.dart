import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Divisor extends StatelessWidget {
  final Color? color;
  final double height;
  const Divisor({super.key, this.height = 0.5, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: height,
      color: color ?? AppColors.neutralLight,
    );
  }
}
