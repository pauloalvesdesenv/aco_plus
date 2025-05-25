import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PedidoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final PedidoModel pedido;
  final PedidoInitReason reason;
  final Function()? onDelete;

  const PedidoTopBar({
    required this.pedido,
    required this.reason,
    this.onDelete,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return reason == PedidoInitReason.kanban
        ? _kanbanWidget(context)
        : _pedidoWidget(context);
  }

  Widget _kanbanWidget(BuildContext context) => Container(
    width: double.maxFinite,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(color: AppColors.primaryMain),
    child: Row(
      children: [
        InkWell(
          onTap: () => onDelete!(),
          child: const Icon(Icons.close, color: Colors.white),
        ),
        const W(16),
        Expanded(
          child: Text(
            pedido.isArchived
                ? '${pedido.localizador} - Arquivado'
                : pedido.localizador,
            style: AppCss.largeBold.setColor(Colors.white).setSize(18),
          ),
        ),
        const Spacer(),
        Tooltip(
          message: 'Acompanhar pedido',
          child: InkWell(
            onTap: () async =>
                context.push('/acompanhamento/pedidos/${pedido.id}'),
            child: Icon(Icons.local_shipping, color: AppColors.white),
          ),
        ),
        const W(12),
        Tooltip(
          message: 'Gerar Relatório do Pedido',
          child: IconButton(
            onPressed: () => pedidoCtrl.onGeneratePDF(pedido),
            icon: Icon(Icons.picture_as_pdf, color: AppColors.white),
          ),
        ),
        const W(12),
        if (pedido.step.isArchivedAvailable && !pedido.isArchived) ...[
          Tooltip(
            message: 'Arquivar pedido',
            child: InkWell(
              onTap: () async => pedidoCtrl
                  .onArchive(context, pedido, isPedido: false)
                  .then((result) {
                    if (result) {
                      kanbanCtrl.setPedido(null);
                    }
                  }),
              child: Icon(Icons.archive, color: AppColors.white, size: 20),
            ),
          ),
          const W(12),
        ],
        if (pedido.isArchived) ...[
          Tooltip(
            message: 'Desarquivar pedido',
            child: IconButton(
              onPressed: () => pedidoCtrl.onUnArchivePedido(context, pedido, 0),
              icon: Icon(Icons.unarchive, color: AppColors.white),
            ),
          ),
          const W(12),
        ],
        Tooltip(
          message: 'Editar pedido',
          child: InkWell(
            onTap: () async => push(context, PedidoCreatePage(pedido: pedido)),
            child: Icon(Icons.edit, color: AppColors.white, size: 20),
          ),
        ),
        const W(12),
        Tooltip(
          message: 'Excluir pedido',
          child: InkWell(
            onTap: () async =>
                pedidoCtrl.onDelete(context, pedido, isPedido: false).then((e) {
                  if (e) {
                    kanbanCtrl.setPedido(null);
                  }
                }),
            child: Icon(Icons.delete, color: AppColors.white, size: 20),
          ),
        ),
      ],
    ),
  );

  Widget _pedidoWidget(BuildContext context) => AppBar(
    title: Text(
      pedido.isArchived
          ? '${pedido.localizador} - Arquivado'
          : pedido.localizador,
      style: AppCss.largeBold.setColor(AppColors.white),
    ),
    backgroundColor: AppColors.primaryMain,
    actions: [
      const W(12),
      Tooltip(
        message: 'Acompanhar pedido',
        child: IconButton(
          onPressed: () => context.push('/acompanhamento/pedidos/${pedido.id}'),
          icon: Icon(Icons.local_shipping, color: AppColors.white),
        ),
      ),
      Tooltip(
        message: 'Gerar Relatório do Pedido',
        child: IconButton(
          onPressed: () => pedidoCtrl.onGeneratePDF(pedido),
          icon: Icon(Icons.picture_as_pdf, color: AppColors.white),
        ),
      ),
      if (pedido.step.isArchivedAvailable && !pedido.isArchived)
        Tooltip(
          message: 'Arquivar pedido',
          child: IconButton(
            onPressed: () => pedidoCtrl.onArchive(context, pedido),
            icon: Icon(Icons.archive, color: AppColors.white),
          ),
        ),
      if (pedido.isArchived)
        Tooltip(
          message: 'Desarquivar pedido',
          child: IconButton(
            onPressed: () => pedidoCtrl.onUnArchivePedido(context, pedido, 2),
            icon: Icon(Icons.unarchive, color: AppColors.white),
          ),
        ),
      Tooltip(
        message: 'Editar pedido',
        child: IconButton(
          onPressed: () async =>
              push(context, PedidoCreatePage(pedido: pedido)),
          icon: Icon(Icons.edit, color: AppColors.white),
        ),
      ),
      Tooltip(
        message: 'Excluir pedido',
        child: IconButton(
          onPressed: () async => pedidoCtrl.onDelete(context, pedido),
          icon: Icon(Icons.delete, color: AppColors.white),
        ),
      ),
    ],
  );
}
