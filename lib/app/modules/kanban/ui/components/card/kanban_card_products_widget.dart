import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class KanbanCardProductsWidget extends StatelessWidget {
  final PedidoModel pedido;
  const KanbanCardProductsWidget({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    final produtosSorted = pedido.produtos.sortedBy(
      (produto) => produto.status.status.index,
    );
    return Padding(
      padding: EdgeInsets.only(top: produtosSorted.isEmpty ? 8 : 4),
      child: produtosSorted.isEmpty
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    'Nenhum produto',
                    style: AppCss.mediumRegular.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const Icon(Icons.inbox_outlined, color: Colors.grey, size: 16),
              ],
            )
          : Column(
              children: produtosSorted
                  .map((produto) => _produtoWidget(produto))
                  .toList(),
            ),
    );
  }

  Widget _produtoWidget(PedidoProdutoModel produto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: produto.status.status.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              produto.produto.descricao,
              style: AppCss.mediumRegular.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const W(8),
          Text(
            '${produto.qtde} Kg',
            style: AppCss.mediumRegular.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Builder(
            builder: (context) {
              final ordem = pedidoCtrl.getOrdemByProduto(produto, true);
              if (ordem == null) return const SizedBox();
              return InkWell(
                onTap: () async {
                  await push(context, OrdemPage(ordem.id));
                  pedidoCtrl.pedidoStream.update();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(1.6),
                  decoration: BoxDecoration(
                    color: produto.status.status.color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 10,
                    color: Colors.grey[900],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
