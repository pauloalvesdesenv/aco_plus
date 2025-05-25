import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_prioridade_bottom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PedidoPrioridadeWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoPrioridadeWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final result = await showPedidoPrioridadeBottom(pedido);
          if (result != null) {
            pedidoCtrl.pedidoStream.add(result);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: pedido.prioridade != null
                ? Colors.orange
                : Color(0xFFF8FCFC),
            border: Border.all(
              color: pedido.prioridade != null
                  ? Colors.black
                  : Colors.grey[400]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.priority_high,
                color: pedido.prioridade != null
                    ? Colors.black
                    : Colors.grey[400]!,
                weight: pedido.prioridade != null ? 600 : 400,
                size: 16,
              ),
              Gap(4),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  pedido.prioridade?.getLabel() ?? 'Sem Prioridade',
                  style: TextStyle(
                    color: pedido.prioridade != null
                        ? Colors.black
                        : Colors.grey[400]!,
                    fontWeight: pedido.prioridade != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
              Gap(4),
            ],
          ),
        ),
      ),
    );
  }
}
