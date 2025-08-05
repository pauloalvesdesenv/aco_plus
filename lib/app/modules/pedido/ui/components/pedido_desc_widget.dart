import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:aco_plus/app/core/components/row_itens_label.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoDescWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoDescWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowItensLabel([
            ItemLabel('Cliente', pedido.cliente.nome),
            ItemLabel(
              'Obra',
              pedido.obra.endereco?.localidade != null
                  ? '${pedido.obra.descricao} - ${pedido.obra.endereco?.localidade.toUpperCase()}'
                  : pedido.obra.descricao,
            ),
          ]),
          const H(16),
          RowItensLabel([
            ItemLabel(
              'Descrição',
              pedido.descricao.isEmpty ? 'Sem descrição' : pedido.descricao,
            ),
            if (pedido.deliveryAt != null)
              ItemLabel(
                'Previsão de Entrega',
                pedido.deliveryAt!.text(),
                isEditable: true,
                onEdit: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: pedido.deliveryAt!,
                  );
                  if (date != null) {
                    pedido.deliveryAt = date;
                    pedidoCtrl.updatePedidoFirestore();
                    NotificationService.showPositive(
                      'Previsão de Entrega Alterada',
                      'A previsão de entrega foi alterada com sucesso',
                    );
                  }
                },
              ),
          ]),
          if (pedido.planilhamento.isNotEmpty) ...[
            const H(16),
            ItemLabel('Planilhamento', pedido.planilhamento),
          ],
        ],
      ),
    );
  }
}
