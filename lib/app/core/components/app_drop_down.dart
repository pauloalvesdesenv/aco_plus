import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AppDropDown<T> extends StatefulWidget {
  final String? label;
  final T item;
  final List<T> itens;
  final String Function(T) itemLabel;
  final void Function(T?) onSelect;
  final Future<T> Function()? onCreated;
  final bool required;
  final bool disable;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final bool hasFilter;
  final TextController? controller;
  final String? hint;

  const AppDropDown({
    this.label,
    required this.item,
    required this.itens,
    required this.itemLabel,
    required this.onSelect,
    this.onCreated,
    this.hint,
    this.focus,
    this.required = true,
    this.disable = false,
    this.hasFilter = false,
    this.nextFocus,
    this.controller,
    super.key,
  });

  @override
  State<AppDropDown<T>> createState() => _AppDropDown<T>();
}

class _AppDropDown<T> extends State<AppDropDown<T>> {
  final TextController _controller = TextController();

  TextController get controller => widget.controller ?? _controller;

  @override
  void initState() {
    if (widget.item != null) {
      final item = widget.itemLabel.call(widget.item);
      if (item.isEmpty || item == 'Selecione') {
        controller.text = '';
      } else {
        controller.text = item;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasFilter == false) return defaultWidget(context);
    return TypeAheadField<T>(
      offset: const Offset(0, 0),
      builder: (_, __, ___) => AppField(
        hint: widget.hint ?? 'Selecione',
        controllerObj: __,
        focusObj: ___,
        label: widget.label,
        isDisable: widget.disable,
        onChanged: (e) {
          setState(() {
            if (e.isEmpty) widget.onSelect.call(null);
          });
        },
        suffixIcon: widget.onCreated == null ? null : Icons.add,
        onSuffix: widget.onCreated == null
            ? null
            : () async {
                final created = await widget.onCreated!.call();
                if (created == null) return;
                widget.onSelect.call(created);
              },
      ),
      controller: controller.controller,
      focusNode: widget.focus ?? controller.focus,
      suggestionsCallback: (pattern) async => widget.itens
          .where(
            (e) =>
                !widget.hasFilter ||
                e.toString().toCompare.contains(pattern.toCompare),
          )
          .toList(),
      hideOnEmpty: true,
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Nenhum item encontrado'),
      ),
      itemBuilder: (context, item) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Text(
          widget.itemLabel.call(item),
          style: AppCss.mediumRegular,
        ),
      ),
      onSelected: (e) {
        setState(() {
          widget.onSelect.call(e);
          controller.focus.unfocus();
          controller.controller.text = widget.itemLabel.call(e);
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          }
        });
      },
    );
  }

  Widget defaultWidget(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.disable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...{
            Text(
              '${widget.label}:${widget.required ? '*' : ''}',
              style: AppCss.smallBold,
            ),
            const H(4),
          },
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutralMedium),
              borderRadius: AppCss.radius8,
              color: widget.disable
                  ? AppColors.neutralMedium.withValues(alpha: 0.4)
                  : null,
            ),
            child: DropdownButton<T>(
              focusNode: widget.focus ?? widget.controller?.focus,
              padding: const EdgeInsets.only(left: 8),
              value: widget.item,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (value) => widget.onSelect.call(value as T),
              hint: Text(widget.hint ?? 'Selecione'),
              icon: widget.disable
                  ? const SizedBox()
                  : IgnorePointer(
                      ignoring: widget.item == null,
                      child: InkWell(
                        onTap: () {
                          if (widget.item != null) {
                            widget.onSelect.call(null as T);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            widget.item != null
                                ? Icons.close
                                : Icons.arrow_drop_down,
                          ),
                        ),
                      ),
                    ),
              items: widget.itens
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(widget.itemLabel.call(e)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String label(value) =>
      (value != null ? (value.label as String) : 'all').replaceAll('\n', ' ');
}
