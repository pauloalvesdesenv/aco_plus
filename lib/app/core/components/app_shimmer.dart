import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool enable;

  const AppShimmer({super.key, required this.child, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return !enable
        ? child
        : IgnorePointer(
          ignoring: true,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            period: const Duration(milliseconds: 800),
            child: child,
          ),
        );
  }
}
