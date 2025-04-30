import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:flutter/material.dart';

class RowItensLabel extends StatelessWidget {
  final List<ItemLabel> itens;
  const RowItensLabel(this.itens, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: itens.map((e) => Expanded(child: e)).toList(),
    );
  }
}
