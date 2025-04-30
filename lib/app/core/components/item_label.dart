import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class ItemLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final FontWeight? weight;
  final bool isDisable;
  final bool isEditable;
  final Function()? onEdit;
  const ItemLabel(
    this.label,
    this.value, {
    this.color,
    this.weight,
    this.isDisable = false,
    this.isEditable = false,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isEditable)
          Text(
            label,
            style: AppCss.minimumBold
                .copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColors.black.withValues(alpha: 0.8),
                )
                .copyWith(
                  decoration: isDisable ? TextDecoration.lineThrough : null,
                  color:
                      isDisable ? AppColors.black.withValues(alpha: 0.3) : null,
                ),
          ),
        if (isEditable)
          GestureDetector(
            onTap: () => onEdit?.call(),
            child: Row(
              children: [
                Text(
                  label,
                  style: AppCss.minimumBold
                      .copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.black.withValues(alpha: 0.8),
                      )
                      .copyWith(
                        decoration:
                            isDisable ? TextDecoration.lineThrough : null,
                        color:
                            isDisable
                                ? AppColors.black.withValues(alpha: 0.3)
                                : null,
                      ),
                ),
                const W(5),
                Icon(Icons.edit, size: 14, color: Colors.grey[700]!),
              ],
            ),
          ),
        Text(
          value,
          style: AppCss.mediumRegular
              .setColor(color ?? AppColors.black)
              .copyWith(
                decoration: isDisable ? TextDecoration.lineThrough : null,
                color:
                    isDisable ? AppColors.black.withValues(alpha: 0.3) : null,
              ),
        ),
      ],
    );
  }
}
