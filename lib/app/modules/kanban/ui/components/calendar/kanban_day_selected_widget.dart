import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_view_model.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KanbanDaySelectedWidget extends StatefulWidget {
  final KanbanUtils utils;
  const KanbanDaySelectedWidget(this.utils, {super.key});

  @override
  State<KanbanDaySelectedWidget> createState() =>
      _KanbanDaySelectedWidgetState();
}

class _KanbanDaySelectedWidgetState extends State<KanbanDaySelectedWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: widget.utils.isDaySelected ? 1 : 0,
      child:
          !widget.utils.isDaySelected
              ? const SizedBox()
              : Builder(
                builder: (context) {
                  final DateTime date = widget.utils.day!.keys.first;
                  final List<PedidoModel> pedidos = widget.utils.day![date]!;
                  return Container(
                    width: 768,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMain,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  kanbanCtrl.setDay(null);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                              const W(16),
                              Expanded(
                                child: Text(
                                  'Pedidos do dia ${DateFormat('dd/MM/yyyy').format(date)}',
                                  style: AppCss.largeBold
                                      .setColor(Colors.white)
                                      .setSize(18),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Total: ${pedidos.length}',
                                style: AppCss.largeBold
                                    .setColor(Colors.white)
                                    .setSize(18),
                              ),
                            ],
                          ),
                        ),

                        // Lista de Pedidos
                        Expanded(
                          child: ListView.separated(
                            itemCount: pedidos.length,
                            shrinkWrap: true,
                            cacheExtent: 200,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder:
                                (_, i) => PedidoItemWidget(
                                  pedido: pedidos[i],
                                  onTap:
                                      (pedido) => kanbanCtrl.setPedido(pedido),
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
