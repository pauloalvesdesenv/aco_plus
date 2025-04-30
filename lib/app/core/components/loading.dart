import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color? color;
  final double width;

  const Loading({this.size = 24, this.width = 4, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: width,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.white),
        ),
      ),
    );
  }
}

class LoadingStreamOut extends StatelessWidget {
  final double size;
  final Color? color;
  final double width;

  const LoadingStreamOut({
    this.size = 24,
    this.width = 4,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: width,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primaryMain,
            ),
          ),
        ),
      ),
    );
  }
}
