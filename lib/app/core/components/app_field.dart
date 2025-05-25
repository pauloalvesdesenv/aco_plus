import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppField extends StatefulWidget {
  final TextController? controller;
  final TextEditingController? controllerObj;
  final FocusNode? focusObj;
  final String? label;
  final String hint;
  final TextInputAction? action;
  final IconData? icon;
  final IconData? suffixIcon;
  final double? suffixIconSize;
  final String? suffixText;
  final void Function()? onSuffix;
  final IconData? prefixIcon;

  final Function()? onPrefix;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final TextInputType type;
  final bool autoFocus;
  final bool required;
  final TextAlign align;
  final int? maxLines;
  final int? minLines;
  final bool isDisable;
  final bool obscure;
  final TextCapitalization? capitalization;

  const AppField({
    this.controller,
    this.label,
    this.align = TextAlign.left,
    this.onChanged,
    this.icon,
    this.suffixIcon,
    this.suffixIconSize,
    this.prefixIcon,
    this.hint = '',
    this.action,
    this.inputFormatters,
    this.onEditingComplete,
    this.onSuffix,
    this.onPrefix,
    this.onTap,
    this.type = TextInputType.text,
    this.autoFocus = false,
    this.required = true,
    this.isDisable = false,
    this.maxLines,
    this.minLines,
    this.obscure = false,
    this.suffixText,
    this.capitalization,
    this.controllerObj,
    this.focusObj,
    super.key,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            '${widget.label!}:${widget.required ? '*' : ''}',
            style: AppCss.smallBold,
          ),
        if (widget.label != null) const H(4),
        IgnorePointer(
          ignoring: widget.isDisable,
          child: TextFormField(
            obscureText: widget.obscure,
            textAlign: widget.align,
            onTap: widget.onTap,
            focusNode: widget.focusObj ?? widget.controller!.focus,
            autofocus: widget.autoFocus,
            controller: widget.controllerObj ?? widget.controller!.controller,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.type,
            textInputAction: widget.action,
            textCapitalization:
                widget.capitalization ?? TextCapitalization.sentences,
            style: AppCss.smallRegular,
            cursorColor: AppColors.neutralDark,
            onEditingComplete: widget.onEditingComplete,
            onChanged: widget.onChanged ?? (e) {},
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isDisable
                  ? Colors.grey[400]!
                  : Colors.transparent,
              hintText: widget.hint,
              hintStyle: AppCss.smallRegular.setColor(AppColors.neutralDark),
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Icon(
                        widget.icon,
                        weight: 800,
                        color: AppColors.primaryDark,
                      ),
                    )
                  : null,
              suffixIcon: getSuffix(),
            ),
          ),
        ),
      ],
    );
  }

  Widget? getSuffix() {
    if (widget.suffixText != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          widget.suffixText!,
          style: AppCss.smallRegular.setColor(AppColors.neutralMedium),
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return InkWell(
        onTap: widget.onSuffix,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Icon(
            widget.suffixIcon,
            weight: 800,
            size: widget.suffixIconSize,
            color: AppColors.neutralMedium,
          ),
        ),
      );
    }
    return null;
  }
}
