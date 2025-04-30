import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoTimelineAcompanhamentoWidget extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoTimelineAcompanhamentoWidget({required this.pedido, super.key});

  @override
  State<PedidoTimelineAcompanhamentoWidget> createState() =>
      _PedidoTimelinAcompanhamentoeWidgetState();
}

class _PedidoTimelinAcompanhamentoeWidgetState
    extends State<PedidoTimelineAcompanhamentoWidget> {
  int index = 0;
  PedidoHistoryType? type;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final histories = pedidoCtrl.getHistoricoAcompanhamento(pedido);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const H(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Histórico do Pedido', style: AppCss.largeBold),
        ),
        const H(16),
        const Divisor(),
        histories.isEmpty
            ? Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: const Text('Sem histórico disponível'),
              )
            : Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: AppColors.primaryMain,
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryMain,
                    ),
                  ),
                  child: Stepper(
                    controller: controller,
                    elevation: 0,
                    controlsBuilder: (context, details) => Container(),
                    margin: EdgeInsets.zero,
                    stepIconBuilder: (i, state) => Icon(
                      histories[i].icon,
                      color: Colors.white,
                      size: 14,
                    ),
                    steps: histories.map((e) {
                      final StepModel step = e.data as StepModel;
                      return Step(
                        content: const SizedBox(),
                        isActive: histories.indexOf(e) == 0,
                        title: Text(step.shipping?.description ?? step.name),
                        subtitle: Text(
                          step.createdAt.textHour(),
                          style: AppCss.smallRegular.setSize(12),
                        ),
                      );
                    }).toList(),
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
