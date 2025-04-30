import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class TypeSelectorWidget<T> extends StatefulWidget {
  final String label;
  final List<T> values;
  final T value;
  final Function(T) onChanged;
  final Function(T) itemLabel;
  final Color? Function(T)? itemColor;
  final Color? Function(T)? itemColorDisable;

  const TypeSelectorWidget({
    required this.label,
    required this.values,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.itemColor,
    this.itemColorDisable,
    super.key,
  });

  @override
  State<TypeSelectorWidget<T>> createState() => _TypeSelectorWidgetState<T>();
}

class _TypeSelectorWidgetState<T> extends State<TypeSelectorWidget<T>> {
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(widget.label, style: AppCss.smallBold),
        if (widget.label.isNotEmpty) const H(8),
        Scrollbar(
          controller: controller,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: double.maxFinite,
              height: 35,
              child: ListView.separated(
                controller: controller,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: widget.values.length,
                separatorBuilder: (_, __) => const W(8),
                itemBuilder:
                    (_, i) => _goalFilterType(widget.value, widget.values[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _goalFilterType(T current, T value) {
    bool isSelected = value == current;
    return GestureDetector(
      onTap: () => widget.onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (widget.itemColor?.call(value) ?? AppColors.primaryLight)
                  : Colors.grey.withValues(alpha: 0.05),
          borderRadius: AppCss.radius16,
        ),
        child: Center(
          child: Text(
            value == null ? 'Todos' : widget.itemLabel.call(value),
            style: AppCss.smallRegular.setColor(AppColors.black),
          ),
        ),
      ),
    );
  }

  String label(value) => value != null ? (value.label as String) : 'all';
}
