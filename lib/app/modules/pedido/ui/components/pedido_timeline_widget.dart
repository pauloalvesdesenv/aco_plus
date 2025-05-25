import 'dart:math';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoTimelineWidget extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoTimelineWidget({required this.pedido, super.key});

  @override
  State<PedidoTimelineWidget> createState() => _PedidoTimelineWidgetState();
}

class _PedidoTimelineWidgetState extends State<PedidoTimelineWidget> {
  int index = 0;
  PedidoHistoryType? type;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<PedidoHistoryModel> histories = widget.pedido.histories.reversed
        .toList();
    if (type != null) {
      histories = histories.where((e) => e.type == type).toList();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const H(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('Linha do Tempo', style: AppCss.largeBold),
              const Spacer(),
              Expanded(
                child: AppDropDown<PedidoHistoryType?>(
                  hint: 'Todos',
                  hasFilter: false,
                  item: type,
                  itens: PedidoHistoryType.values,
                  itemLabel: (e) => e?.name ?? 'Todos',
                  onSelect: (e) {
                    setState(() {
                      type = e;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const H(8),
        const Divisor(),
        histories.isEmpty
            ? Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: const Text('Sem histórico disponível'),
              )
            : Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: AppColors.primaryMain,
                  colorScheme: ColorScheme.light(
                    primary: AppColors.primaryMain,
                  ),
                ),
                child: Container(
                  color: Colors.grey[50],
                  width: double.maxFinite,
                  height: 300,
                  child: Stepper(
                    key: Key((Random().nextDouble() * 200).toStringAsFixed(2)),
                    controller: controller,
                    elevation: 0,
                    controlsBuilder: (context, details) => Container(),
                    margin: EdgeInsets.zero,
                    stepIconBuilder: (i, state) =>
                        Icon(histories[i].icon, color: Colors.white, size: 14),
                    steps: histories
                        .map(
                          (e) => Step(
                            content: const SizedBox(),
                            label: Text(e.title),
                            isActive: histories.indexOf(e) == 0,
                            title: Row(
                              children: [
                                Expanded(child: Text(e.title)),
                                Text(
                                  e.createdAt.textHour(),
                                  style: AppCss.smallRegular.setSize(12),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              e.description,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
        const H(16),
      ],
    );
  }

  bool getIsActive(int currentIndex, int index) {
    if (currentIndex <= index) {
      return true;
    } else {
      return false;
    }
  }
}
