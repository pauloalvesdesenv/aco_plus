import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_controller.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pai_pedido_corte_dobra_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pai_pedido_produtos_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_anexos_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_armacao_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_checks_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_comentarios_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_corte_dobra_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_desc_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_entrega_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_filhos_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_financ_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_prioridade_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_produtos_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_status_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_steps_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_tags_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_timeline_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_top_bar.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_users_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_vinculados_widget.dart';
import 'package:flutter/material.dart';

enum PedidoInitReason { page, kanban, archived }

class PedidoPage extends StatefulWidget {
  final PedidoModel pedido;
  final PedidoInitReason reason;
  final Function()? onDelete;

  const PedidoPage({
    required this.pedido,
    required this.reason,
    this.onDelete,
    super.key,
  });

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    if (widget.reason != PedidoInitReason.kanban) {
      setWebTitle('Pedido ${widget.pedido.localizador}');
    }
    pedidoCtrl.onInitPage(widget.pedido).then((_) {
      notificacaoCtrl.onSetPedidoViewed(widget.pedido);
    });
    super.initState();
  }

  @override
  void dispose() {
    pedidoCtrl.setPedido(null);
    super.dispose();
  }

  bool get isKanban => widget.reason == PedidoInitReason.kanban;
  bool get isArchived => widget.reason == PedidoInitReason.archived;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamOut(
      stream: pedidoCtrl.pedidoStream.listen,
      builder: (_, pedido) =>
          isKanban ? _kanbanReasonWidget(pedido) : _pedidoReasonWidget(pedido),
    );
  }

  AppScaffold _pedidoReasonWidget(PedidoModel pedido) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: PedidoTopBar(
        pedido: pedido,
        reason: widget.reason,
        onDelete: widget.onDelete,
      ),
      body: body(pedido),
    );
  }

  Widget _kanbanReasonWidget(PedidoModel pedido) {
    return Material(surfaceTintColor: Colors.transparent, child: body(pedido));
  }

  Widget body(PedidoModel pedido) {
    return Column(
      children: [
        if (isKanban)
          PedidoTopBar(
            pedido: pedido,
            reason: widget.reason,
            onDelete: widget.onDelete,
          ),
        Expanded(
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PedidoPrioridadeWidget(pedido),
                  Expanded(child: PedidoTagsWidget(pedido)),
                  PedidoUsersWidget(pedido),
                  const W(12),
                ],
              ),
              Column(
                children: [
                  PedidoDescWidget(pedido),
                  const Divisor(),
                  PedidoStepsWidget(pedido),
                  const Divisor(),
                  if (pedido.pedidosFilhos.isEmpty) ...[
                    PedidoStatusWidget(pedido),
                    const Divisor(),
                    if (pedido.isAguardandoEntradaProducao()) ...[
                      PedidoProdutosWidget(pedido),
                      const Divisor(),
                    ],
                    if (!pedido.isAguardandoEntradaProducao())
                      Column(
                        children: [
                          PedidoCorteDobraWidget(pedido),
                          const Divisor(),
                          PedidoProdutosWidget(pedido),
                          const Divisor(),
                          if (pedido.tipo == PedidoTipo.cda) ...[
                            PedidoArmacaoWidget(pedido),
                            const Divisor(),
                          ],
                        ],
                      ),
                  ],

                  if (pedido.pedidosFilhos.isNotEmpty) ...[
                    PaiPedidoCorteDobraWidget(pedido),
                    const Divisor(),
                    PaiPedidoProdutosWidget(pedido),
                    const Divisor(),
                  ],

                  if (pedido.instrucoesEntrega.isNotEmpty) ...[
                    PedidoEntregaWidget(pedido),
                    const Divisor(),
                  ],
                  if (pedido.instrucoesFinanceiras.isNotEmpty ||
                      pedido.instrucoesFinanceiras.isNotEmpty) ...[
                    PedidoFinancWidget(pedido),
                    const Divisor(),
                  ],
                  PedidoAnexosWidget(pedido),
                  const Divisor(),
                  PedidoChecksWidget(pedido),
                  const Divisor(),
                  if (pedido.pedidosFilhos.isEmpty) ...[
                    PedidoVinculadosWidget(
                      pedido: pedido,
                      vinculados: pedido.getPedidosVinculados(),
                    ),
                    const Divisor(),
                  ],
                  if (pedido.pedidosFilhos.isNotEmpty) ...[
                    PedidoFilhosWidget(
                      pedido: pedido,
                      filhos: pedido.getPedidosFilhos(),
                    ),
                    const Divisor(),
                  ],
                  PedidoCommentsWidget(pedido),
                  const Divisor(),
                  if (pedido.histories.isNotEmpty)
                    PedidoTimelineWidget(pedido: pedido),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
