import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class AppBottom<T> extends StatelessWidget {
  final String title;
  final Widget child;
  final int height;
  final void Function()? onDone;
  final Widget? titleLeading;

  const AppBottom({
    required this.title,
    required this.child,
    this.height = 400,
    this.onDone,
    this.titleLeading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: height + MediaQuery.of(context).viewInsets.bottom,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.all(8),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          AppColors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_backspace),
                    ),
                    const Spacer(),
                    IconButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.all(8),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          onDone != null
                              ? AppColors.primaryMain
                              : Colors.grey[400],
                        ),
                      ),
                      onPressed: () => onDone?.call(),
                      icon: const Icon(Icons.done),
                    ),
                  ],
                ),
                const H(8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(title, style: AppCss.largeBold),
                      const Spacer(),
                      if (titleLeading != null) titleLeading!,
                    ],
                  ),
                ),
                const H(16),
                child,
              ],
            ),
          );
        },
      ),
    );
  }
}
