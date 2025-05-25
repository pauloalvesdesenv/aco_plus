import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? margin;
  final List<double>? padding;
  final double? radius;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? child;

  const AppContainer({
    this.color,
    this.margin,
    this.padding,
    this.radius,
    this.borderColor,
    this.borderWidth,
    this.width,
    this.height,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin == null ? null : EdgeInsets.all(margin!),
      padding: padding == null
          ? null
          : padding!.length == 1
          ? EdgeInsets.all(padding!.first)
          : (padding!.length == 2
                ? EdgeInsets.symmetric(
                    horizontal: padding!.first,
                    vertical: padding![1],
                  )
                : EdgeInsets.fromLTRB(
                    padding![0],
                    padding![1],
                    padding![2],
                    padding![3],
                  )),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius == null ? null : BorderRadius.circular(radius!),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth ?? 1),
      ),
      child: child,
    );
  }
}
