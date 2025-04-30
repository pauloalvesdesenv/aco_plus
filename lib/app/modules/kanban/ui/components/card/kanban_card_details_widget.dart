import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:flutter/material.dart';

class KanbanCardDetailsWidget extends StatelessWidget {
  final PedidoModel pedido;
  final bool showDeliveryAt;
  const KanbanCardDetailsWidget(
    this.pedido, {
    super.key,
    this.showDeliveryAt = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        if (showDeliveryAt)
          if (pedido.deliveryAt != null)
            _detailWidget(
              Icons.timer_outlined,
              value: pedido.deliveryAt!.toddMM(),
            ),
        if (pedido.archives.isNotEmpty)
          _detailWidget(
            Icons.file_present,
            value: pedido.archives.length.toString(),
          ),
        if (pedido.checks.isNotEmpty)
          _detailWidget(
            Icons.checklist,
            value:
                '${pedido.checks.where((e) => e.isCheck).length}/${pedido.checks.length}',
          ),
        if (pedido.comments.isNotEmpty)
          _detailWidget(
            Icons.comment_outlined,
            value: pedido.comments.length.toString(),
          ),
      ],
    );
  }

  Widget _detailWidget(IconData icon, {String? value}) {
    return IntrinsicWidth(
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF787C86), size: 14),
          if (value != null) ...[
            const W(4),
            Text(
              value,
              style: const TextStyle(color: Color(0xFF787C86), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
