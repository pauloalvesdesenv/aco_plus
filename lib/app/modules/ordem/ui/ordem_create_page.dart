import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_pedidos_selecionados_bottom.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
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
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${ordemCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Ordem',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          if ((widget.ordem != null &&
                  usuario.permission.ordem.contains(
                    UserPermissionType.update,
                  )) ||
              (widget.ordem == null &&
                  usuario.permission.ordem.contains(UserPermissionType.create)))
            IconLoadingButton(() async {
              await ordemCtrl.onConfirm(context, widget.ordem);
            }),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: ordemCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
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
                child: Column(
                  children: [
                    AppDropDown<ProdutoModel?>(
                      disable: form.isEdit,
                      label: 'Produto',
                      item: form.produto,
                      itens: FirestoreClient.produtos.data,
                      itemLabel: (e) => e!.descricao,
                      onSelect: (e) {
                        form.produto = e;
                        form.produtos.clear();
                        form.materiaPrima = null;
                        ordemCtrl.formStream.update();
                      },
                    ),
                    const H(16),
                    AppDropDown<MateriaPrimaModel?>(
                      disable: form.produto == null,
                      label: 'Materia Prima',
                      item: form.materiaPrima,
                      itens: [
                        MateriaPrimaModel.empty(),
                        ...FirestoreClient.materiaPrimas.data.where(
                          (e) =>
                              e.produto.id == form.produto?.id &&
                              e.status == MateriaPrimaStatus.disponivel,
                        ),
                      ],
                      itemLabel: (e) =>
                          '${e!.fabricanteModel.nome} - ${e.corridaLote}',
                      onSelect: (e) {
                        form.materiaPrima = e;
                        ordemCtrl.formStream.update();
                      },
                    ),
                    const H(16),
                    AppField(
                      onTap: () {
                        setState(() {
                          form.localizador.controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset:
                                form.localizador.controller.value.text.length,
                          );
                        });
                      },
                      label: 'Filtrar por localizador',
                      required: false,
                      controller: form.localizador,
                      onChanged: (e) {
                        ordemCtrl.formStream.update();
                      },
                    ),
                    const H(16),
                    Row(
                      children: [
                        Expanded(
                          child: AppDropDown<SortType>(
                            label: 'Ordernar por',
                            item: form.sortType,
                            itens: SortType.values,
                            itemLabel: (e) => e.name,
                            onSelect: (e) {
                              form.sortType = e ?? SortType.alfabetic;
                              ordemCtrl.formStream.update();
                            },
                          ),
                        ),
                        const W(16),
                        Expanded(
                          child: AppDropDown<SortOrder>(
                            label: 'Ordernar',
                            item: form.sortOrder,
                            itens: SortOrder.values,
                            itemLabel: (e) => e.name,
                            onSelect: (e) {
                              form.sortOrder = e ?? SortOrder.asc;
                              ordemCtrl.formStream.update();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (form.produto != null)
                Builder(
                  builder: (_) {
                    List<PedidoProdutoModel> produtos = ordemCtrl
                        .getPedidosPorProduto(
                          form.produto!,
                          ordem: widget.ordem,
                        );
                    produtos = produtos
                        .where(
                          (produto) => !form.produtos
                              .map((e) => e.id)
                              .contains(produto.id),
                        )
                        .toList();

                    return Column(
                      children: [
                        for (PedidoProdutoModel produto in produtos)
                          _itemProduto(
                            isEnable: produto.isAvailable,
                            produto: produto,
                            check: form.produtos
                                .map((e) => e.id)
                                .contains(produto.id),
                            onTap: () {
                              form.produtos
                                      .map((e) => e.id)
                                      .contains(produto.id)
                                  ? form.produtos.removeWhere(
                                      (e) => e.id == produto.id,
                                    )
                                  : form.produtos.add(produto);
                              ordemCtrl.formStream.update();
                            },
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
        _bottom(form),
      ],
    );
  }

  Container _bottom(OrdemCreateModel form) {
    List<PedidoProdutoModel> produtos = form.produto != null
        ? ordemCtrl.getPedidosPorProduto(form.produto!, ordem: widget.ordem)
        : <PedidoProdutoModel>[];
    produtos = produtos
        .where((produto) => form.produtos.map((e) => e.id).contains(produto.id))
        .toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.black.withValues(alpha: 0.04),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () =>
                      showOrderCreatePedidosSelecionadosBottom(widget.ordem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PESO TOTAL SELECIONADO PARA ESTA ORDEM: ${produtos.map((e) => e.qtde).fold(.0, (a, b) => a + b).toKg()}'
                            .toUpperCase(),
                        style: AppCss.mediumBold.setSize(20),
                      ),
                      if (produtos.isNotEmpty)
                        Text(
                          'Pedidos selecionados: ${produtos.length}',
                          style: AppCss.minimumRegular
                              .setSize(14)
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  form.produtos.clear();
                  ordemCtrl.formStream.update();
                },
                icon: Icon(Icons.delete_outline, color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
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
                          'Previsão de Entrega: ${produto.pedido.deliveryAt.text()}',
                          style: AppCss.minimumRegular
                              .copyWith(fontSize: 12)
                              .setColor(AppColors.neutralDark),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar'),
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
