import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_checkbox.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';

class OrdemCreatePage extends StatefulWidget {
  final OrdemModel? ordem;
  const OrdemCreatePage({this.ordem, super.key});

  @override
  State<OrdemCreatePage> createState() => _OrdemCreatePageState();
}

class _OrdemCreatePageState extends State<OrdemCreatePage> {
  @override
  void initState() {
    ordemCtrl.onInitCreatePage(widget.ordem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeAvoid: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              )),
          title: Text('${ordemCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Ordem',
              style: AppCss.largeBold.setColor(AppColors.white)),
          actions: [
            IconLoadingButton(() async => await ordemCtrl.onConfirm(context, widget.ordem, false))
          ],
          backgroundColor: AppColors.primaryMain,
        ),
        body: StreamOut(stream: ordemCtrl.formStream.listen, builder: (_, form) => body(form)));
  }

  Widget body(OrdemCreateModel form) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppDropDown<ProdutoModel?>(
                  disable: form.isEdit,
                  label: 'Produto',
                  item: form.produto,
                  itens: FirestoreClient.produtos.data,
                  itemLabel: (e) => e!.descricao,
                  onSelect: (e) {
                    form.produto = e;
                    form.produtos.clear();
                    ordemCtrl.formStream.update();
                  },
                ),
              ),
              const H(16),
              if (form.isEdit)
                for (var produto in widget.ordem!.produtos)
                  _itemProduto(
                      produto: produto,
                      check: produto.selected,
                      onTap: () {
                        produto.selected = !produto.selected;
                        ordemCtrl.formStream.update();
                      }),
              if (form.produto != null)
                for (var produto in ordemCtrl.getPedidosPorProduto(form.produto!))
                  _itemProduto(
                      produto: produto,
                      check: form.produtos.contains(produto),
                      onTap: () {
                        if (form.produtos.contains(produto)) {
                          form.produtos.remove(produto);
                        } else {
                          form.produtos.add(produto);
                        }
                        ordemCtrl.formStream.update();
                      }),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.black.withOpacity(0.04), width: 1))),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total: ${[
                    if (widget.ordem != null) ...widget.ordem!.produtos,
                    ...form.produtos
                  ].map((e) => e.qtde).fold(.0, (a, b) => a + b)}Kg',
                  style: AppCss.mediumBold.setSize(16),
                ),
              ),
              IconButton(
                  onPressed: () {
                    form.produtos.clear();
                    ordemCtrl.formStream.update();
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.white,
                  ))
            ],
          ),
        )
      ],
    );
  }

  Widget _itemProduto({
    required PedidoProdutoModel produto,
    required bool check,
    required void Function() onTap,
  }) {
    return Container(
      color: produto.status.status != PedidoProdutoStatus.separado
          ? AppColors.black.withOpacity(0.04)
          : null,
      child: IgnorePointer(
        ignoring: produto.status.status != PedidoProdutoStatus.separado,
        child: InkWell(
          onTap: onTap,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black.withOpacity(0.04), width: 1),
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
                          '${produto.cliente.nome} - ${produto.obra.descricao}',
                        ),
                        Text(
                          '${produto.qtde}Kg',
                          style: AppCss.mediumBold.setSize(16),
                        ),
                      ],
                    ),
                  ),
                  AppCheckbox(value: check, onChanged: (_) {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}