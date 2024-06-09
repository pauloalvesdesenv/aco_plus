import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/checklist/check_list_widget.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoChecksWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoChecksWidget(
    this.pedido, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckListWidget(
            items: pedido.checks,
            onChanged: () => pedidoCtrl.updatePedidoFirestore(),
          ),
        ],
      ),
    );
  }
}
