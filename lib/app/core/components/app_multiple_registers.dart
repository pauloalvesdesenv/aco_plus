import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

class AppMultipleRegisters<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget createPage;
  final Function(T) onEdit;
  final Function(T) onAdd;
  final List<T> itens;
  final Widget Function(T) titleBuilder;

  const AppMultipleRegisters({
    required this.icon,
    required this.title,
    required this.createPage,
    required this.onEdit,
    required this.onAdd,
    required this.itens,
    required this.titleBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: GestureDetector(
            onTap: () async {
              final result = await push(context, createPage);
              if (result != null) {
                onAdd(result as T);
              }
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon),
              title: Text(
                title + (itens.isNotEmpty ? '(${itens.length})' : ''),
                style: AppCss.mediumRegular,
              ),
              trailing: const Icon(Icons.add),
            ),
          ),
        ),
        for (T item in itens)
          GestureDetector(
            onTap: () => onEdit.call(item),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 8),
              title: titleBuilder(item),
              leading: Text(
                (itens.indexOf(item) + 1).toString(),
                style: AppCss.minimumRegular,
              ),
              trailing: const Icon(Icons.edit_outlined, size: 20),
            ),
          ),
      ],
    );
  }
}
