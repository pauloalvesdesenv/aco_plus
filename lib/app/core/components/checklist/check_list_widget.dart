import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/checklist/check_item_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class CheckListWidget extends StatefulWidget {
  final List<CheckItemModel> items;
  final void Function(CheckItemModel) onChanged;
  final void Function(CheckItemModel) onAdd;
  final void Function(CheckItemModel) onRemove;

  const CheckListWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<CheckListWidget> createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  final TextController _titleEC = TextController();

  bool get isDone =>
      widget.items.isNotEmpty && widget.items.every((e) => e.isCheck);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text('Check List', style: AppCss.largeBold),
                  if (isDone)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primaryMain,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.items.isNotEmpty) ...[
              Text(
                '${widget.items.where((e) => e.isCheck).length} de ${widget.items.length}',
                style: AppCss.mediumRegular.copyWith(color: Colors.grey[700]),
              ),
              const W(8),
              Text(
                '(${((widget.items.where((e) => e.isCheck).toList().length / widget.items.length) * 100).toStringAsFixed(0)}%)',
                style: AppCss.mediumRegular.copyWith(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
        const H(16),
        ...widget.items.map((e) => _itemWidget(e)),
        const H(8),
        _addWidget(),
      ],
    );
  }

  Widget _itemWidget(CheckItemModel item) {
    return InkWell(
      onTap: () {
        item.isCheck = !item.isCheck;
        widget.onChanged.call(item);
      },
      child: Container(
        height: 40,
        width: double.maxFinite,
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: item.isCheck ? AppColors.primaryMain : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: item.isCheck ? AppColors.primaryMain : Colors.grey,
                ),
              ),
              child:
                  item.isCheck
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
            const W(12),
            Expanded(
              child: Text(
                item.title,
                style: AppCss.mediumRegular.copyWith(
                  color:
                      item.isCheck
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.black,
                  decoration:
                      item.isCheck
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: InkWell(
                onTap: () => widget.onRemove.call(item),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMain,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addWidget() {
    bool isEnabled = _titleEC.text.isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppField(
            autoFocus: false,
            hint: 'Adicione um item',
            controller: _titleEC,
            onChanged: (_) => setState(() {}),
            onEditingComplete: () => _onAdd(),
          ),
        ),
        const W(8),
        InkWell(
          onTap: () => _onAdd(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.primaryMain : Colors.grey[200]!,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.add,
              color: isEnabled ? Colors.white : Colors.grey[700]!,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  void _onAdd() {
    if (_titleEC.text.isEmpty) return;
    widget.onAdd.call(CheckItemModel(title: _titleEC.text, isCheck: false));
    _titleEC.controller.clear();
  }
}
