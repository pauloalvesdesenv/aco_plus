import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/components/app_bottom.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:flutter/material.dart';

Future<void> showOrderCreatePedidosSelecionadosBottom(
  OrdemModel? ordem,
) async => showModalBottomSheet(
  backgroundColor: AppColors.white,
  context: contextGlobal,
  isScrollControlled: true,
  builder: (_) => OrderCreatePedidosSelecionadosBottom(ordem),
);

class OrderCreatePedidosSelecionadosBottom extends StatefulWidget {
  final OrdemModel? ordem;
  const OrderCreatePedidosSelecionadosBottom(this.ordem, {super.key});

  @override
  State<OrderCreatePedidosSelecionadosBottom> createState() =>
      _OrderCreatePedidosSelecionadosBottomState();
}

class _OrderCreatePedidosSelecionadosBottomState
    extends State<OrderCreatePedidosSelecionadosBottom> {
  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: ordemCtrl.formStream.listen,
      builder: (_, form) {
        List<PedidoProdutoModel> produtos = ordemCtrl.getPedidosPorProduto(
          form.produto!,
          ordem: widget.ordem,
        );
        produtos = produtos
            .where(
              (produto) => form.produtos.map((e) => e.id).contains(produto.id),
            )
            .toList();

        return AppBottom(
          title: 'Pedidos Selecionados',
          height: 500,
          onDone: () => Navigator.pop(context),
          child: Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        for (var produto in produtos) {
                          form.produtos.map((e) => e.id).contains(produto.id)
                              ? form.produtos.removeWhere(
                                  (e) => e.id == produto.id,
                                )
                              : form.produtos.add(produto);
                          ordemCtrl.formStream.update();
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Remover todos',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const H(16),
                for (PedidoProdutoModel produto in produtos)
                  _itemProduto(
                    isEnable: produto.isAvailable,
                    produto: produto,
                    check: form.produtos.map((e) => e.id).contains(produto.id),
                    onTap: () {
                      form.produtos.map((e) => e.id).contains(produto.id)
                          ? form.produtos.removeWhere((e) => e.id == produto.id)
                          : form.produtos.add(produto);
                      ordemCtrl.formStream.update();
                      if (form.produtos.isEmpty) Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemProduto({
    required PedidoProdutoModel produto,
    required bool check,
    required void Function() onTap,
    required bool isEnable,
  }) {
    return Container(
      color: !isEnable ? AppColors.black.withValues(alpha: 0.04) : null,
      child: IgnorePointer(
        ignoring: !isEnable,
        child: InkWell(
          onTap: onTap,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.black.withValues(alpha: 0.04),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto.pedido.localizador,
                          style: AppCss.mediumBold.setSize(16),
                        ),
                        Text(
                          produto.qtde.toKg(),
                          style: AppCss.mediumBold.setSize(14).setHeight(0.8),
                        ),
                        const H(2),
                        Row(
                          children: [
                            Text(
                              '${produto.cliente.nome} - ${produto.obra.descricao}',
                              style: const TextStyle(),
                            ),
                            const W(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: produto.pedido.tipo.backgroundColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                produto.pedido.tipo.label,
                                style: AppCss.minimumBold
                                    .setColor(
                                      produto.pedido.tipo.foregroundColor,
                                    )
                                    .setSize(11),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Previsão de Entrega: ${produto.pedido.deliveryAt?.text()}',
                          style: AppCss.minimumRegular
                              .copyWith(fontSize: 12)
                              .setColor(AppColors.neutralDark),
                        ),
                      ],
                    ),
                  ),
                  if(isEnable) TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                    label: const Text('Remover'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
