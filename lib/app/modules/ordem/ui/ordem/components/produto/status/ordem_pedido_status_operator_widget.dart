import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:flutter/material.dart';

class OrdemPedidoStatusOperatorWidget extends StatelessWidget {
  final PedidoProdutoModel produto;
  final OrdemModel ordem;
  const OrdemPedidoStatusOperatorWidget({
    super.key,
    required this.produto,
    required this.ordem,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      PedidoProdutoStatus.aguardandoProducao,
      PedidoProdutoStatus.produzindo,
      PedidoProdutoStatus.pronto,
    ];

    return IgnorePointer(
      ignoring: produto.isPaused,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: statuses
            .map(
              (status) => InkWell(
                onTap: status == produto.status.status
                    ? null
                    : () =>
                          ordemCtrl.onSelectProdutoStatus(ordem, produto, status),
                child: Tooltip(
                  enableFeedback: status != produto.status.status,
                  message: status == produto.status.status
                      ? 'Este pedido atualmente está ${status.label}'
                      : 'Clique para alterar para ${status.label}',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withValues(
                        alpha: status == produto.status.status ? 1 : 0.1,
                      ),
                    ),
                    child: Text(
                      status.label,
                      style: AppCss.minimumRegular
                          .setSize(16)
                          .copyWith(
                            color:
                                (status == PedidoProdutoStatus.pronto
                                        ? Colors.white
                                        : Colors.black)
                                    .withValues(
                                      alpha: status == produto.status.status
                                          ? 1
                                          : 0.4,
                                    ),
                          ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
