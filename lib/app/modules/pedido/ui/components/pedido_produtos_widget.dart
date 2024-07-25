import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PedidoProdutosWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoProdutosWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: pedido.isAguardandoEntradaProducao(),
      child: Column(
        children:
            pedido.produtos.map((produto) => _produtoWidget(produto)).toList(),
      ),
    );
  }

  Column _produtoWidget(PedidoProdutoModel produto) {
    return Column(
      children: [
        ExpansionTile(
          title: Row(
            children: [
              Text('${produto.produto.nome} - ${produto.produto.descricao}'),
              const W(16),
              if (produto.status.status.index >=
                  PedidoProdutoStatus.aguardandoProducao.index) ...[
                Builder(builder: (context) {
                  final ordem = pedidoCtrl.getOrdemByProduto(produto);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(ordem?.id ?? 'N/A',
                        style: AppCss.mediumRegular.copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  );
                }),
                const W(4),
              ],
              if (!pedido.isAguardandoEntradaProducao())
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: produto.statusess.last
                          .getStatusView()
                          .color
                          .withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(produto.statusess.last.getStatusView().label,
                      style: AppCss.mediumRegular.setSize(12)),
                )
            ],
          ),
          trailing:
              pedido.isAguardandoEntradaProducao() ? const SizedBox() : null,
          childrenPadding: const EdgeInsets.all(16),
          subtitle: Text(
            '${produto.qtde}Kg',
            style: AppCss.minimumRegular,
          ),
          children: [
            for (final status
                in produto.statusess.map((e) => e.copyWith()).toList())
              Builder(builder: (context) {
                final isLast = status.id == produto.statusess.last.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: status
                              .getStatusView()
                              .color
                              .withOpacity(isLast ? 0.4 : 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(status.getStatusView().label,
                            style: AppCss.mediumRegular.setSize(14).setColor(
                                AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                      ),
                      Text(status.createdAt.textHour(),
                          style: AppCss.minimumRegular.setColor(
                              AppColors.black.withOpacity(isLast ? 1 : 0.4))),
                    ],
                  ),
                );
              })
          ],
        ),
        const Divisor(),
      ],
    );
  }
}
