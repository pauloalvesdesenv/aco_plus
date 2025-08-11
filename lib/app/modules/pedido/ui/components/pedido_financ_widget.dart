import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoFinancWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoFinancWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Financeiro', style: AppCss.largeBold),
            if (pedido.pedidoFinanceiro.isNotEmpty) ...[
              const H(16),
              ItemLabel('Pedido Financeiro', pedido.pedidoFinanceiro),
            ],
            if (pedido.instrucoesFinanceiras.isNotEmpty) ...[
              const H(16),
              ItemLabel('Instruções Financeiras', pedido.instrucoesFinanceiras),
            ],
          ],
        ),
      ),
    );
  }
}
