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

class PaiPedidoProdutoWidget extends StatefulWidget {
  final PedidoModel pedido;
  final PedidoProdutoModel produto;
  const PaiPedidoProdutoWidget(this.pedido, this.produto, {super.key});

  @override
  State<PaiPedidoProdutoWidget> createState() => _PaiPedidoProdutoWidgetState();
}

class _PaiPedidoProdutoWidgetState extends State<PaiPedidoProdutoWidget> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.pedido
                .getPedidoProdutoStatus(widget.produto)
                .getColorPedidoProdutoPai(isExpanded)
                .withValues(alpha: 0.1);
    return Column(
      children: [
      InkWell(
        onTap: widget.pedido.getPedidosFilhos().isEmpty ? null : () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.produto.produto.nome} ${widget.produto.produto.descricao}',
                    style: AppCss.mediumBold,
                  ),
                ),
                Builder(
                  builder: (context) {
                    final direcionado = widget.pedido.getQtdeDirecionada(
                      widget.produto,
                    );
                    if (direcionado <= 0) {
                      return Text(
                        '${widget.produto.qtde}Kg',
                        style: AppCss.mediumBold,
                      );
                    }
                    return Text(
                      '${widget.produto.qtde}Kg',
                      style: AppCss.mediumBold.copyWith(
                        color: Colors.grey[700],
                        decorationThickness: 1.6,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey[700],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if(isExpanded)...[

        for (final filho in widget.pedido.getPedidosFilhos().where(
          (e) =>
              e.produtos.any((p) => p.produto.id == widget.produto.produto.id),
        ))
          _filhoWidget(filho, widget.produto),
        Builder(
          builder: (context) {
            if (widget.pedido.getQtdeDirecionada(widget.produto) <= 0) {
              return SizedBox.shrink();
            }
            return _restanteWidget(backgroundColor,
              (widget.produto.qtde -
                      widget.pedido.getQtdeDirecionada(widget.produto))
                  .toInt(),
            );
          },
        ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: filho.status.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(filho.localizador, style: AppCss.minimumRegular),
            ),
            Text(
              '-${filho.produtos.firstWhere((p) => p.produto.id == produto.produto.id).qtde}Kg',
              style: AppCss.minimumRegular.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _restanteWidget(Color color, int qtde) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
      child: Row(
        children: [
          Expanded(child: Text('Restante', style: AppCss.minimumRegular)),
          Text(
            '${qtde}Kg',
            style: AppCss.minimumRegular.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
