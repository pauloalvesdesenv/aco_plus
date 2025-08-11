import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';

class PaiPedidoProdutosWidget extends StatefulWidget {
  final PedidoModel pedido;
  const PaiPedidoProdutosWidget(this.pedido, {super.key});

  @override
  State<PaiPedidoProdutosWidget> createState() =>
      _PaiPedidoProdutosWidgetState();
}

class _PaiPedidoProdutosWidgetState extends State<PaiPedidoProdutosWidget> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.pedido.isAguardandoEntradaProducao(),
      child: Column(
        children: widget.pedido.produtos
            .map((produto) => _produtoWidget(produto))
            .toList(),
      ),
    );
  }

  Widget _produtoWidget(PedidoProdutoModel produto) {
    return Column(
      children: [
        Container(
          color: widget.pedido
              .getPedidoProdutoStatus(produto)
              .getColorPedidoProdutoPai()
              .withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${produto.produto.nome} ${produto.produto.descricao}',
                  style: AppCss.mediumBold,
                ),
              ),
              Builder(
                builder: (context) {
                  final qtde = widget.pedido.getQtdeDirecionada(produto);
                  if (qtde > 0) {
                    return Text(
                      '${qtde}Kg',
                      style: AppCss.mediumBold.copyWith(
                        color: Colors.grey[700],
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                        decorationColor: Colors.grey[700],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Builder(
                builder: (context) {
                  final qtdeDirecionada = widget.pedido.getQtdeDirecionada(
                    produto,
                  );
                  final qtdeRestante = produto.qtde - qtdeDirecionada;

                  return qtdeRestante > 0
                      ? SizedBox(width: 8)
                      : const SizedBox.shrink();
                },
              ),
              Builder(
                builder: (context) {
                  final qtde =
                      produto.qtde - widget.pedido.getQtdeDirecionada(produto);
                  if (qtde > 0) {
                    return Text('${qtde}Kg', style: AppCss.mediumBold);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        for (final filho in widget.pedido.getPedidosFilhos().where(
          (e) => e.produtos.any((p) => p.produto.id == produto.produto.id),
        ))
          _filhoWidget(filho, produto),
        const Divisor(),
      ],
    );
  }

  Widget _filhoWidget(PedidoModel filho, PedidoProdutoModel produto) {
    return InkWell(
      onTap: () async {
        await push(
          context,
          PedidoPage(pedido: filho, reason: PedidoInitReason.page),
        );
        pedidoCtrl.setPedido(filho);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: filho.status.color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(filho.localizador, style: AppCss.minimumRegular),
            ),
            Text(
              '${filho.produtos.firstWhere((p) => p.produto.id == produto.produto.id).qtde}Kg',
              style: AppCss.minimumRegular,
            ),
          ],
        ),
      ),
    );
  }
}
