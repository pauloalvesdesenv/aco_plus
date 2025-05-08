import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/date_picker_field.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/formatters/uper_case_formatter.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/ui/cliente_create_simplify_bottom.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_order_edit_bottom.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_produto_view_model.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class PedidoCreatePage extends StatefulWidget {
  final PedidoModel? pedido;
  const PedidoCreatePage({this.pedido, super.key});

  @override
  State<PedidoCreatePage> createState() => _PedidoCreatePageState();
}

class _PedidoCreatePageState extends State<PedidoCreatePage> {
  final FocusNode focusQtde = FocusNode();
  ExpansionTileController tileController = ExpansionTileController();

  @override
  void initState() {
    pedidoCtrl.onInitCreatePage(widget.pedido);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (await showConfirmDialog(
              'Deseja realmente sair?',
              'Os dados do pedido serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${pedidoCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Pedido',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          if ((widget.pedido != null &&
                  usuario.permission.pedido.contains(
                    UserPermissionType.update,
                  )) ||
              (widget.pedido == null &&
                  usuario.permission.pedido.contains(
                    UserPermissionType.create,
                  )))
            IconLoadingButton(
              () async =>
                  await pedidoCtrl.onConfirm(context, widget.pedido, false),
            ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: pedidoCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(PedidoCreateModel form) {
    return ListView(
      children: [
        _pedidoDetalhesWidget(form),
        const Divisor(),
        _produtoAddWidget(form),
        for (PedidoProdutoCreateModel produto in form.produtos)
          _produtoItemWidget(form, produto),
      ],
    );
  }

  Builder _produtoItemWidget(
    PedidoCreateModel form,
    PedidoProdutoCreateModel produto,
  ) {
    return Builder(
      builder: (context) {
        bool isDisabled =
            form.isEdit &&
            FirestoreClient.ordens.data
                .expand((e) => e.produtos.map((e) => e.id))
                .any((e) => e == produto.id);
        return ColorFiltered(
          colorFilter:
              isDisabled
                  ? ColorFilter.mode(
                    Colors.grey.withValues(alpha: 0.4),
                    BlendMode.softLight,
                  )
                  : const ColorFilter.mode(Colors.transparent, BlendMode.color),
          child: IgnorePointer(
            ignoring: isDisabled,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey[200] : Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const W(24),
                  Text(
                    (form.produtos.indexOf(produto) + 1).toString(),
                    style: AppCss.mediumBold,
                  ),
                  const W(18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                produto.produtoModel?.descricao ?? '',
                                style: AppCss.mediumBold.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            if (isDisabled)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Produto já foi adicionado há uma ordem',
                                  style: AppCss.mediumRegular.copyWith(
                                    color: Colors.red[500]!,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text('Quantidade: ${produto.qtde.text} Kg'),
                      ],
                    ),
                  ),
                  if (!isDisabled) ...[
                    IconButton(
                      onPressed: () async {
                        final qtde = await showPedidoOrderEditBottom(produto);
                        if (qtde != null) {
                          produto.qtde.text = qtde.toString();
                          pedidoCtrl.formStream.update();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.red),
                    ),
                    const W(8),
                    IconButton(
                      onPressed: () {
                        showConfirmDialog(
                          'Deseja remover bitola?',
                          'A bitola será removida do pedido',
                        ).then((value) {
                          if (value) {
                            form.produtos.remove(produto);
                            pedidoCtrl.formStream.update();
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                    const W(16),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _produtoAddWidget(PedidoCreateModel form) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                AppDropDown<ProdutoModel?>(
                  label: 'Produto',
                  controller: form.produto.produtoEC,
                  nextFocus: form.produto.qtde.focus,
                  item: form.produto.produtoModel,
                  itens:
                      FirestoreClient.produtos.data
                          .where(
                            (e) =>
                                !form.produtos
                                    .map((e) => e.produtoModel?.id)
                                    .contains(e.id),
                          )
                          .toList(),
                  itemLabel: (e) => e?.descricao ?? 'Selecione',
                  onSelect: (e) {
                    //TODO
                    // tileController.collapse();
                    form.produto.produtoModel = e;
                    form.produto.qtde.focus.requestFocus();
                    pedidoCtrl.formStream.update();
                  },
                ),
                const H(6),
                AppField(
                  label: 'Quantidade',
                  type: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  controller: form.produto.qtde,
                  action: TextInputAction.done,
                  suffixText: 'Kg',
                  onChanged: (_) => pedidoCtrl.formStream.update(),
                  onEditingComplete: () {
                    if (form.produto.isEnable) {
                      FocusScope.of(context).unfocus();
                      form.produtos.add(form.produto);
                      form.produto = PedidoProdutoCreateModel();
                      form.produto.produtoEC.controller.clear();
                      form.produto.produtoEC.focus.requestFocus();
                      pedidoCtrl.formStream.update();
                    }
                  },
                ),
              ],
            ),
          ),
          const W(8),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: IconButton(
              onPressed:
                  !form.produto.isEnable
                      ? null
                      : () {
                        form.produtos.add(form.produto);
                        form.produto = PedidoProdutoCreateModel();
                        form.produto.produtoEC.controller.clear();
                        form.produto.produtoEC.focus.requestFocus();
                        pedidoCtrl.formStream.update();
                      },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  form.produto.isEnable
                      ? AppColors.primaryMain
                      : AppColors.black.withValues(alpha: 0.3),
                ),
              ),
              icon: Icon(Icons.add, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  ExpansionTile _pedidoDetalhesWidget(PedidoCreateModel form) {
    return ExpansionTile(
      initiallyExpanded: true,
      maintainState: true,
      controller: tileController,
      key: const Key('pedidoDetalhes'),
      leading: const Icon(Icons.info_outline),
      title: Text('Informações do Pedido', style: AppCss.mediumBold),
      subtitle: Text(form.getDetails(), style: AppCss.minimumRegular),
      childrenPadding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Localizador',
          inputFormatters: [UpperCaseFormatter()],
          capitalization: TextCapitalization.characters,
          controller: form.localizador,
          type: TextInputType.name,
          action: TextInputAction.next,
          onChanged: (_) => pedidoCtrl.formStream.update(),
          onEditingComplete: () {
            if (form.localizador.text.isEmpty) {
              NotificationService.showNegative(
                'Localizador não pode ser vazio',
                'Não será possível salvar o pedido sem um localizador',
                position: NotificationPosition.bottom,
              );
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
        const H(16),
        AppField(
          label: 'Planilhamento',
          controller: form.planilhamento,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
        const H(16),
        AppDropDown<PedidoTipo?>(
          label: 'Tipo',
          item: form.tipo,
          itens: PedidoTipo.values,
          itemLabel: (e) => e!.label,
          onSelect: (e) {
            form.tipo = e;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppField(
          label: 'Descrição',
          controller: form.descricao,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
        const H(16),
        AppDropDown<ClienteModel?>(
          hasFilter: true,
          label: 'Cliente',
          item: form.cliente,
          itens: FirestoreClient.clientes.data,
          onCreated: () async {
            ClienteModel? cliente = await showClienteCreateSimplifyBottom();
            assert(cliente != null);
            form.cliente = cliente;
            form.obra = form.cliente!.obras.first;
            pedidoCtrl.formStream.update();
            return null;
          },
          itemLabel: (e) => e!.nome,
          onSelect: (e) async {
            form.cliente = e;
            form.obra = null;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppDropDown<ObraModel?>(
          label: 'Obra',
          item: form.obra,
          disable: form.cliente == null,
          itens:
              form.cliente?.obras
                  .where((e) => e.status == ObraStatus.emAndamento)
                  .toList() ??
              [],
          itemLabel: (e) => e?.descricao ?? 'Selecione',
          onSelect: (e) {
            form.obra = e;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppDropDown<ChecklistModel?>(
          label: 'Modelo de checklist',
          hasFilter: true,
          item: form.checklist,
          itens: FirestoreClient.checklists.data,
          itemLabel: (e) => e!.nome,
          onSelect: (e) async {
            form.checklist = e;
            pedidoCtrl.formStream.update();
          },
        ),
        if (widget.pedido == null) ...[
          const H(16),
          AppDropDown<StepModel?>(
            label: 'Etapa Inicial',
            hasFilter: false,
            item: form.step,
            itens: FirestoreClient.steps.data,
            itemLabel: (e) => e?.name ?? 'Selecione',
            onSelect: (e) async {
              form.step = e!;
              pedidoCtrl.formStream.update();
            },
          ),
        ],
        const H(16),
        DatePickerField(
          required: false,
          label: 'Previsão de Entrega',
          item: form.deliveryAt,
          onChanged: (value) {
            form.deliveryAt = value;
            pedidoCtrl.formStream.update();
          },
        ),
        const H(16),
        AppField(
          label: 'Pedido Financeiro',
          controller: form.pedidoFinanceiro,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Instruções Financeiras',
          controller: form.instrucoesFinanceiras,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Instruções de Entrega',
          controller: form.instrucoesEntrega,
          onChanged: (_) => pedidoCtrl.formStream.update(),
        ),
      ],
    );
  }
}
