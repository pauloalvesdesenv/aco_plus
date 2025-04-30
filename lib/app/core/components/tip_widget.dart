import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class TipWidget extends StatelessWidget {
  final Function() onTap;
  final String label;
  final bool isSelected;

  const TipWidget({
    required this.onTap,
    required this.label,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : null,
            borderRadius: AppCss.radius16,
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryDark : AppColors.neutralMedium,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppCss.smallRegular.setColor(
                isSelected ? AppColors.white : AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
