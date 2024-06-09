import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';

class PedidoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final PedidoModel pedido;
  final PedidoInitReason reason;
  final Function()? onDelete;

  const PedidoTopBar(
      {required this.pedido, required this.reason, this.onDelete, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return reason == PedidoInitReason.page
        ? _pedidoWidget(context)
        : _kanbanWidget(context);
  }

  Widget _kanbanWidget(BuildContext context) => Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(color: AppColors.primaryMain),
      child: Row(
        children: [
          InkWell(
            onTap: () => onDelete!(),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          const W(16),
          Text(
            pedido.localizador,
            style: AppCss.largeBold.setColor(Colors.white).setSize(18),
          ),
          const Spacer(),
          InkWell(
              onTap: () async =>
                  push(context, PedidoCreatePage(pedido: pedido)),
              child: Icon(
                Icons.edit,
                color: AppColors.white,
                size: 20,
              )),
          const W(12),
          InkWell(
              onTapCancel: () async => pedidoCtrl.onDelete(context, pedido),
              child: Icon(
                Icons.delete,
                color: AppColors.white,
                size: 20,
              )),
        ],
      ));

  Widget _pedidoWidget(BuildContext context) => AppBar(
        title: Text(pedido.localizador,
            style: AppCss.largeBold.setColor(AppColors.white)),
        backgroundColor: AppColors.primaryMain,
        actions: [
          IconButton(
              onPressed: () async =>
                  push(context, PedidoCreatePage(pedido: pedido)),
              icon: Icon(Icons.edit, color: AppColors.white)),
          IconButton(
              onPressed: () async => pedidoCtrl.onDelete(context, pedido),
              icon: Icon(Icons.delete, color: AppColors.white))
        ],
      );
}
