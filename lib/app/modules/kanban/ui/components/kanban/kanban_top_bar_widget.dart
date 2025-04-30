import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_filter_widget.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/kanban/shimmer/kanban_top_bar_shimmer_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

class KanbanTopBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const KanbanTopBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return const _KanbanTopbarConcreteWidget();
  }
}

class _KanbanTopbarConcreteWidget extends StatefulWidget {
  const _KanbanTopbarConcreteWidget();

  @override
  State<_KanbanTopbarConcreteWidget> createState() =>
      _KanbanTopbarConcreteWidgetState();
}

class _KanbanTopbarConcreteWidgetState
    extends State<_KanbanTopbarConcreteWidget> {
  late InfoPopupController controller;
  @override
  Widget build(BuildContext context) {
    return StreamOut<KanbanUtils>(
      loading: const KanbanTopBarShimmerWidget(),
      stream: kanbanCtrl.utilsStream.listen,
      builder: (_, utils) => AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(
            Icons.menu,
            color: AppColors.white,
          ),
        ),
        title:
            Text('Kanban', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          InfoPopupWidget(
            onControllerCreated: (_) {
              controller = _;
              utils.controller = _;
              kanbanCtrl.utilsStream.update();
            },
            onAreaPressed: (e) {},
            dismissTriggerBehavior: PopupDismissTriggerBehavior.manuel,
            customContent: () => KanbanFilterWidget(utils),
            contentOffset: const Offset(-10, 0),
            infoPopupDismissed: () {},
            arrowTheme: InfoPopupArrowTheme(color: AppColors.white),
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list,
                        color: AppColors.white,
                      ),
                      style: utils.hasFilter()
                          ? ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.redAccent),
                            )
                          : null),
                ),
                if (utils.hasFilter())
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          utils.getFilterSteps().toString(),
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryMain,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                if (utils.hasFilter())
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        utils.search.text = '';
                        utils.cliente = null;
                        controller.dismissInfoPopup();
                        kanbanCtrl.utilsStream.update();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Icon(
                          Icons.close,
                          size: 12,
                          color: AppColors.primaryMain,
                        )),
                      ),
                    ),
                  )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                if (utils.view == KanbanViewMode.calendar) {
                  utils.view = KanbanViewMode.kanban;
                } else {
                  utils.view = KanbanViewMode.calendar;
                }
                kanbanCtrl.utilsStream.update();
              },
              icon: Icon(
                utils.view != KanbanViewMode.calendar
                    ? Icons.calendar_month
                    : Icons.view_kanban,
                color: AppColors.white,
              )),
          if (usuario.permission.pedido.contains(UserPermissionType.create))
            IconButton(
                onPressed: () async {
                  await push(context, const PedidoCreatePage());
                  final pedidos = FirestoreClient.pedidos.data;
                  pedidos.sort((a, b) => a.id.compareTo(b.id));
                  kanbanCtrl.onAccept(pedidos.last.step, pedidos.last, 0);
                },
                icon: Icon(
                  Icons.add,
                  color: AppColors.white,
                ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
    );
  }
}
