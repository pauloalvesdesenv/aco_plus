import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_users_bottom.dart';
import 'package:flutter/material.dart';
import 'package:separated_row/separated_row.dart';

class KanbanCardUsersWidget extends StatelessWidget {
  final PedidoModel pedido;
  final WidgetViewMode viewMode;
  const KanbanCardUsersWidget(this.pedido, {required this.viewMode, super.key});

  @override
  Widget build(BuildContext context) {
    return SeparatedRow(
      separatorBuilder: (_, i) => const W(4),
      children: [
        if (pedido.users.isEmpty) ...[
          InkWell(
            onTap: () async {
              await showPedidoUsersBottom(pedido);
              kanbanCtrl.utilsStream.update();
            },
            child: AppAvatar(
              radius: viewMode == WidgetViewMode.minified ? 9 : 14,
              icon: Icons.person_add,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ],
        ...pedido.users.map(
          (e) => InkWell(
            onTap: () async {
              await showPedidoUsersBottom(pedido);
              kanbanCtrl.utilsStream.update();
            },
            child: AppAvatar(
              radius: viewMode == WidgetViewMode.minified ? 9 : 14,
              name: e.nome,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
      ],
    );
  }
}
