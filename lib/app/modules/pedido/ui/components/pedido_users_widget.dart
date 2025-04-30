import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_users_bottom.dart';
import 'package:flutter/material.dart';
import 'package:separated_row/separated_row.dart';

class PedidoUsersWidget extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoUsersWidget(this.pedido, {super.key});

  @override
  State<PedidoUsersWidget> createState() => _PedidoUsersWidgetState();
}

class _PedidoUsersWidgetState extends State<PedidoUsersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: SeparatedRow(
        separatorBuilder: (_, i) => const W(4),
        children: [
          if (widget.pedido.users.isEmpty) ...[
            InkWell(
              onTap: () async {
                await showPedidoUsersBottom(widget.pedido);
                pedidoCtrl.pedidoStream.update();
                setState(() {});
              },
              child: AppAvatar(
                radius: 14,
                icon: Icons.person_add,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
          ...widget.pedido.users.map((e) => InkWell(
                onTap: () async {
                  await showPedidoUsersBottom(widget.pedido);
                  setState(() {});
                },
                child: AppAvatar(
                    radius: 14,
                    name: e.nome.getInitials(),
                    backgroundColor: Colors.grey[200]),
              )),
        ],
      ),
    );
  }
}
