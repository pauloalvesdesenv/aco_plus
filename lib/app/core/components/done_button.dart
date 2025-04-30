import 'package:aco_plus/app/core/components/loading.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class IconLoadingButton extends StatefulWidget {
  final IconData icon;
  final Future<void> Function() onPressed;
  const IconLoadingButton(this.onPressed, {this.icon = Icons.done, super.key});

  @override
  State<IconLoadingButton> createState() => _IconLoadingButtonState();
}

class _IconLoadingButtonState extends State<IconLoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Padding(padding: EdgeInsets.all(16), child: Loading(size: 16))
        : IconButton(
            onPressed: () async {
              setState(() => isLoading = true);
              try {
                await widget.onPressed.call();
              } catch (_) {}
              setState(() => isLoading = false);
            },
            icon: Icon(widget.icon, color: AppColors.white),
          );
  }
}
