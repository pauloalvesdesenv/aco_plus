import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrdemStatusWidget extends StatelessWidget {
  final OrdemModel ordem;
  const OrdemStatusWidget({super.key, required this.ordem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Status', style: AppCss.largeBold)),
              if (usuario.isNotOperador)
                if (ordem.produtos.isNotEmpty)
                  InkWell(
                    onTap: () => ordemCtrl.showBottomChangeProdutosStatus(
                      ordem.produtos,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            Text(
                              'Mover todos para',
                              style: AppCss.mediumRegular.setSize(12),
                            ),
                            const W(2),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          const H(8),
          if (ordem.pedidos.isEmpty)
            Row(
              children: [
                const Icon(Symbols.brightness_empty),
                const W(8),
                Text(
                  'Ordem vazia, não contem pedidos.',
                  style: AppCss.mediumRegular.setColor(Colors.grey[700]!),
                ),
              ],
            ),
          if (ordem.pedidos.isNotEmpty) ...[
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
                      '${ordem.qtdeAguardando().toKg()} (${(ordem.getPrcntgAguardando() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgAguardando(),
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
                      '${ordem.qtdeProduzindo().toKg()} (${(ordem.getPrcntgProduzindo() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgProduzindo(),
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
                    Expanded(
                      child: Text('Pronto', style: AppCss.mediumRegular),
                    ),
                    Text(
                      '${ordem.qtdePronto().toKg()} (${(ordem.getPrcntgPronto() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgPronto(),
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
        ],
      ),
    );
  }
}
