import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoCorteDobraWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoCorteDobraWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Corte e Dobra', style: AppCss.largeBold),
          const H(8),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aguardando Produção',
                      style: AppCss.mediumRegular,
                    ),
                  ),
                  Text(
                    '${pedido.getQtdeAguardandoProducao().toKg()} (${(pedido.getPrcntgAguardandoProducao() * 100).percent}%)',
                  ),
                ],
              ),
              const H(8),
              LinearProgressIndicator(
                value: pedido.getPrcntgAguardandoProducao(),
                backgroundColor: PedidoProdutoStatus.aguardandoProducao.color
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(
                  PedidoProdutoStatus.aguardandoProducao.color,
                ),
              ),
            ],
          ),
          const H(16),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Produzindo', style: AppCss.mediumRegular),
                  ),
                  Text(
                    '${pedido.getQtdeProduzindo().toKg()} (${(pedido.getPrcntgProduzindo() * 100).percent}%)',
                  ),
                ],
              ),
              const H(8),
              LinearProgressIndicator(
                value: pedido.getPrcntgProduzindo(),
                backgroundColor: PedidoProdutoStatus.produzindo.color
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(
                  PedidoProdutoStatus.produzindo.color,
                ),
              ),
            ],
          ),
          const H(16),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('Pronto', style: AppCss.mediumRegular)),
                  Text(
                    '${pedido.getQtdePronto().toKg()} (${(pedido.getPrcntgPronto() * 100).percent}%)',
                  ),
                ],
              ),
              const H(8),
              LinearProgressIndicator(
                value: pedido.getPrcntgPronto(),
                backgroundColor: PedidoProdutoStatus.pronto.color.withValues(
                  alpha: 0.3,
                ),
                valueColor: AlwaysStoppedAnimation(
                  PedidoProdutoStatus.pronto.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
