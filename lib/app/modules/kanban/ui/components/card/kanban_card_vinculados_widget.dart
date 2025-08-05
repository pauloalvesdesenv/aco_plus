import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';

class KanbanCardVinculadosWidget extends StatelessWidget {
  final PedidoModel pedido;
  const KanbanCardVinculadosWidget({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    final vinculados = pedido.getPedidosVinculados();
    if (vinculados.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vinculados',
            style: AppCss.mediumRegular.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const H(2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: vinculados
                .map((vinculado) => _vinculadoWidget(context, vinculado))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _vinculadoWidget(BuildContext context, PedidoModel vinculado) {
    return InkWell(
      onTap: () => push(context, PedidoPage(pedido: vinculado, reason: PedidoInitReason.page)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: AppColors.primaryMain.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                vinculado.localizador,
                style: AppCss.mediumRegular.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const W(8),
            Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
