import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/widget_view_mode.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_comments_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_notificao_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_products_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_step_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_tags_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_users_widget.dart';
import 'package:aco_plus/app/modules/kanban/ui/components/card/kanban_card_vinculados_widget.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class KanbanCardCalendarWidget extends StatefulWidget {
  final PedidoModel pedido;
  final CalendarFormat calendarFormat;
  final WidgetViewMode viewMode;
  const KanbanCardCalendarWidget(
    this.pedido,
    this.calendarFormat, {
    this.viewMode = WidgetViewMode.normal,
    super.key,
  });

  @override
  State<KanbanCardCalendarWidget> createState() =>
      _KanbanCardCalendarWidgetState();
}

class _KanbanCardCalendarWidgetState extends State<KanbanCardCalendarWidget> {
  KanbanCardStepViewMode stepViewMode = KanbanCardStepViewMode.collapsed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contrains) {
        bool isSM = contrains.maxWidth < 100;
        return InkWell(
          onTap: () => kanbanCtrl.setPedido(widget.pedido),
          child: StreamOut(
            stream: FirestoreClient.notificacoes.dataStream.listen,
            builder: (context, value) {
              final notificacoes = notificacaoCtrl.getNotificaoByUsuarioPedido(
                value,
                usuarioCtrl.usuario!,
                widget.pedido,
              );
              return Container(
                width: double.maxFinite,
                padding: const EdgeInsets.fromLTRB(0.03, 0.03, 0.03, 1),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getColor(widget.pedido),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.pedido.prioridade != null) ...[
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                widget.pedido.prioridade!.getLabelShort(),
                                style: AppCss.minimumRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                          if (widget.pedido.comments.any((e) => e.isFixed)) ...[
                            Icon(Icons.warning, color: Colors.orange),
                            const W(4),
                          ],
                          if (widget.pedido.tags.isNotEmpty) ...[
                            Expanded(
                              child: KanbanCardTagsWidget(
                                pedido: widget.pedido,
                                viewMode: widget.viewMode,
                              ),
                            ),
                            const W(8),
                            if (widget.pedido.pedidosVinculados.isNotEmpty) ...[
                              Icon(
                                Icons.link,
                                color: Colors.grey[700],
                                size: 16,
                              ),
                              const W(8),
                            ],
                            Text(widget.pedido.getQtdeTotal().toKg()),
                            if (notificacoes.isNotEmpty) ...[
                              const W(8),
                              KanbanCardNotificacaoWidget(),
                            ],
                          ],
                        ],
                      ),
                      const H(4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.pedido.localizador,
                              style: AppCss.minimumRegular.copyWith(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (!isSM)
                            if (widget.pedido.users.isNotEmpty)
                              KanbanCardUsersWidget(
                                widget.pedido,
                                viewMode:
                                    stepViewMode ==
                                            KanbanCardStepViewMode.expanded ||
                                        widget.calendarFormat ==
                                            CalendarFormat.week
                                    ? WidgetViewMode.normal
                                    : WidgetViewMode.minified,
                              ),
                        ],
                      ),
                      const H(4),
                      KanbanCardStepWidget(
                        widget.pedido.step,
                        viewMode: stepViewMode,
                        calendarFormat: widget.calendarFormat,
                      ),
                      const H(4),
                      if (widget.viewMode == WidgetViewMode.expanded) ...[
                        KanbanCardProductsWidget(pedido: widget.pedido),
                        Builder(
                          builder: (context) {
                            final comments = widget.pedido.comments
                                .where((e) => e.isFixed)
                                .toList();
                            if (comments.isEmpty) return const SizedBox();
                            return KanbanCardCommentsWidget(comments: comments);
                          },
                        ),
                        KanbanCardVinculadosWidget(pedido: widget.pedido),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getColor(PedidoModel pedido) {
    if (pedido.comments.any((e) => e.isFixed)) {
      return const Color.fromARGB(255, 255, 227, 177);
    }
    if (pedido.prioridade == null) {
      return const Color(0xFFFFFFFF);
    }
    return const Color.fromARGB(255, 255, 249, 239);
  }
}
