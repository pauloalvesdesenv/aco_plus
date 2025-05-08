import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoItemWidget extends StatelessWidget {
  final PedidoModel pedido;
  final Function(PedidoModel) onTap;
  const PedidoItemWidget({
    super.key,
    required this.pedido,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(pedido),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.neutralLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pedido.localizador, style: AppCss.mediumBold),
                      Text('${pedido.cliente.nome} - ${pedido.obra.descricao}'),
                      Text(
                        pedido.produtos
                            .map(
                              (e) =>
                                  '${'${e.produto.descricao} - ${e.qtde}'}Kg',
                            )
                            .join(', '),
                        style: AppCss.minimumRegular
                            .setSize(11)
                            .setColor(AppColors.black),
                      ),
                      if (pedido.deliveryAt != null)
                        Text(
                          'Previsão de Entrega: ${pedido.deliveryAt.text()}',
                          style: AppCss.minimumRegular
                              .setSize(13)
                              .setColor(AppColors.neutralDark)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                const W(8),
                ColorFiltered(
                  colorFilter:
                      pedido.isAguardandoEntradaProducao()
                          ? ColorFilter.mode(Colors.grey[200]!, BlendMode.srcIn)
                          : const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.color,
                          ),
                  child: Row(
                    children: [
                      _progressChartWidget(
                        PedidoProdutoStatus.aguardandoProducao,
                        pedido.getPrcntgAguardandoProducao(),
                      ),
                      const W(16),
                      _progressChartWidget(
                        PedidoProdutoStatus.produzindo,
                        pedido.getPrcntgProduzindo(),
                      ),
                      const W(16),
                      _progressChartWidget(
                        PedidoProdutoStatus.pronto,
                        pedido.getPrcntgPronto(),
                      ),
                    ],
                  ),
                ),
                const W(16),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.neutralMedium,
                ),
              ],
            ),
          ),
          if (pedido.steps.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(0.5),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: pedido.step.color.withValues(alpha: 0.15),
                ),
                child: Text(
                  pedido.steps.last.step.name,
                  style: AppCss.minimumBold
                      .setSize(9)
                      .setColor(Colors.grey[800]!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _progressChartWidget(PedidoProdutoStatus status, double porcentagem) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: porcentagem,
          backgroundColor: status.color.withValues(alpha: 0.2),
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(status.color),
        ),
        Text(
          '${(porcentagem * 100).percent}%',
          style: AppCss.minimumBold.setSize(10),
        ),
      ],
    );
  }
}
