import 'package:flutter/material.dart';

class H extends StatelessWidget {
  final double height;

  const H(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
