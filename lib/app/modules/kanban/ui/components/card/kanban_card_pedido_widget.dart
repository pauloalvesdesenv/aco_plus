import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_details_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_notificao_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_tags_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_users_widget.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class KanbanCardPedidoWidget extends StatelessWidget {
  final PedidoModel pedido;
  final WidgetViewMode viewMode;
  const KanbanCardPedidoWidget(
    this.pedido, {
    this.viewMode = WidgetViewMode.normal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => kanbanCtrl.setPedido(pedido),
      child: StreamOut(
        stream: FirestoreClient.notificacoes.dataStream.listen,
        builder: (context, value) {
          final notificacoes = notificacaoCtrl.getNotificaoByUsuarioPedido(
            value,
            usuarioCtrl.usuario!,
            pedido,
          );
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notificacoes.isNotEmpty
                  ? const Color.fromARGB(255, 255, 241, 240)
                  : (pedido.prioridade == null
                        ? Color(0xFFFFFFFF)
                        : const Color.fromARGB(255, 255, 249, 239)),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (pedido.prioridade != null) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black, width: 0.8),
                          ),
                          child: Text(
                            pedido.prioridade!.getLabelShort(),
                            style: AppCss.minimumRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                      if (pedido.tags.isNotEmpty) ...[
                        Expanded(
                          child: KanbanCardTagsWidget(
                            pedido: pedido,
                            viewMode: viewMode,
                          ),
                        ),
                        const W(8),
                        Text(pedido.getQtdeTotal().toKg()),
                        if (notificacoes.isNotEmpty) ...[
                          const W(8),
                          KanbanCardNotificacaoWidget(),
                        ],
                      ],
                    ],
                  ),
                  const H(8),
                  Text(pedido.localizador),
                  const H(8),
                  Row(
                    children: [
                      Expanded(child: KanbanCardDetailsWidget(pedido)),
                      KanbanCardUsersWidget(pedido, viewMode: viewMode),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
