import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoStatusWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoStatusWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Text('Status de Produção', style: AppCss.largeBold)),
          InkWell(
            onTap:
                pedido.isChangeStatusAvailable
                    ? () => pedidoCtrl.onChangePedidoStatus(pedido)
                    : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: (pedido.isAguardandoEntradaProducao()
                        ? Colors.grey
                        : pedido.status.color)
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Text(
                      pedido.isAguardandoEntradaProducao()
                          ? 'AGUARDANDO ENTRADA'
                          : pedido.status.label,
                      style: AppCss.mediumRegular.setSize(12),
                    ),
                    if (pedido.isChangeStatusAvailable) ...{
                      const W(2),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.black.withValues(alpha: 0.6),
                      ),
                    },
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
