import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/text_controller_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<double?> showPedidoOrderEditBottom(
  PedidoProdutoCreateModel produto,
) async => showModalBottomSheet(
  backgroundColor: AppColors.white,
  context: contextGlobal,
  isScrollControlled: true,
  builder: (_) => PedidoOrderEditBottom(produto),
);

class PedidoOrderEditBottom extends StatefulWidget {
  final PedidoProdutoCreateModel produto;
  const PedidoOrderEditBottom(this.produto, {super.key});

  @override
  State<PedidoOrderEditBottom> createState() => _PedidoOrderEditBottomState();
}

class _PedidoOrderEditBottomState extends State<PedidoOrderEditBottom> {
  final TextController qtdeEC = TextController();

  @override
  void initState() {
    qtdeEC.text = widget.produto.qtde.text;
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => KeyboardVisibilityBuilder(
            builder:
                (context, isVisible) => Container(
                  height: 390,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    children: [
                      const H(16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.all(16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppColors.white,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                AppColors.black,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.keyboard_backspace),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Editar Produto', style: AppCss.largeBold),
                            const H(16),
                            AppDropDown<ProdutoModel>(
                              label: 'Produto',
                              disable: true,
                              controller: widget.produto.produtoEC,
                              nextFocus: widget.produto.qtde.focus,
                              item: widget.produto.produtoModel!,
                              itens: [widget.produto.produtoModel!],
                              itemLabel: (e) => e.descricao,
                              onSelect: (e) {},
                            ),
                            const H(8),
                            AppField(
                              label: 'Quantidade',
                              type: const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              controller: qtdeEC,
                              action: TextInputAction.done,
                              suffixText: 'Kg',
                              onChanged: (_) => setState(() {}),
                              onEditingComplete: () {
                                if (qtdeEC.doubleValue > 0) {
                                  FocusScope.of(context).unfocus();
                                  Navigator.pop(context, qtdeEC.doubleValue);
                                }
                              },
                            ),
                            const H(16),
                            AppTextButton(
                              isEnable: widget.produto.qtde.doubleValue > 0,
                              label: 'Confirmar',
                              onPressed:
                                  () => Navigator.pop(
                                    context,
                                    qtdeEC.doubleValue,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }
}
