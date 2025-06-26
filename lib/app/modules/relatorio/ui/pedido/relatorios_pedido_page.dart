import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoriosPedidoPage extends StatefulWidget {
  const RelatoriosPedidoPage({super.key});

  @override
  State<RelatoriosPedidoPage> createState() => _RelatoriosPedidoPageState();
}

class _RelatoriosPedidoPageState extends State<RelatoriosPedidoPage> {
  @override
  void initState() {
    setWebTitle('Relatórios de Pedidos');
    relatorioCtrl.pedidoViewModelStream.add(RelatorioPedidoViewModel());
    relatorioCtrl.onCreateRelatorioPedido();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Relatórios de Pedido',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.pedidoViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed: model.relatorio != null
                  ? () => relatorioCtrl.onExportRelatorioPedidoPDF(
                      relatorioCtrl.pedidoViewModel,
                    )
                  : null,
              icon: Icon(
                Icons.picture_as_pdf_outlined,
                color: model.relatorio != null ? null : Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
      body: StreamOut(
        stream: relatorioCtrl.pedidoViewModelStream.listen,
        builder: (_, model) => ListView(
          children: [
            _filterWidget(model),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            if ([
              RelatorioPedidoTipo.totaisPedidos,
              RelatorioPedidoTipo.totais,
            ].contains(model.tipo)) ...[
              _totaisWidget(),
              Divisor(color: Colors.grey[700]!, height: 1.5),
            ],
            if ([
              RelatorioPedidoTipo.totaisPedidos,
              RelatorioPedidoTipo.pedidos,
            ].contains(model.tipo)) ...[
              _pedidosWidget(model),
              Divisor(color: Colors.grey[700]!, height: 1.5),
            ],
          ],
        ),
      ),
    );
  }

  Column _pedidosWidget(RelatorioPedidoViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Pedidos:', style: AppCss.mediumBold),
        ),
        const Divisor(),
        ...model.relatorio!.pedidos.map((e) => itemRelatorio(e)),
      ],
    );
  }

  Padding _filterWidget(RelatorioPedidoViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDropDown<ClienteModel?>(
            label: 'Cliente',
            hasFilter: true,
            item: model.cliente,
            itens: [null, ...FirestoreClient.clientes.data],
            itemLabel: (e) => e?.nome ?? 'TODOS',
            onSelect: (e) {
              model.cliente = e;
              model.status.clear();
              relatorioCtrl.pedidoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioPedido();
            },
          ),
          const H(16),
          AppDropDownList<PedidoProdutoStatus>(
            label: 'Status',
            addeds: model.status,
            itens: PedidoProdutoStatus.values,
            itemLabel: (e) => e.label,
            itemColor: (e) => e.color.withValues(alpha: 0.4),
            onChanged: () {
              relatorioCtrl.pedidoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioPedido();
            },
          ),
          const H(16),
          AppDropDownList<ProdutoModel>(
            label: 'Bitolas',
            addeds: model.produtos,
            itens: FirestoreClient.produtos.data,
            itemLabel: (e) => e.descricao,
            onChanged: () {
              relatorioCtrl.pedidoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioPedido();
            },
          ),
          const H(16),
          Row(
            children: [
              Expanded(
                child: AppDropDown<SortType>(
                  label: 'Ordernar por',
                  item: model.sortType,
                  itens: model.sortTypes,
                  itemLabel: (e) => e.name,
                  onSelect: (e) {
                    model.sortType = e ?? SortType.alfabetic;
                    relatorioCtrl.pedidoViewModelStream.add(model);
                    relatorioCtrl.onCreateRelatorioPedido();
                  },
                ),
              ),
              const W(16),
              Expanded(
                child: AppDropDown<SortOrder>(
                  label: 'Ordernar',
                  item: model.sortOrder,
                  itens: SortOrder.values,
                  itemLabel: (e) => e.name,
                  onSelect: (e) {
                    model.sortOrder = e ?? SortOrder.asc;
                    relatorioCtrl.pedidoViewModelStream.add(model);
                    relatorioCtrl.onCreateRelatorioPedido();
                  },
                ),
              ),
            ],
          ),
          const H(16),
          AppDropDown<RelatorioPedidoTipo>(
            label: 'Tipo de Relatório',
            item: model.tipo,
            itens: RelatorioPedidoTipo.values,
            itemLabel: (e) => e.label,
            onSelect: (e) {
              model.tipo = e!;
              relatorioCtrl.pedidoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioPedido();
            },
          ),
        ],
      ),
    );
  }

  Column _totaisWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        itemInfo(
          'Total Geral',
          relatorioCtrl.getPedidosTotal().toKg(),
          labelStyle: AppCss.mediumBold,
          valueStyle: AppCss.mediumBold,
          padding: const EdgeInsets.all(16),
        ),
        const Divisor(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Totais por status:', style: AppCss.mediumBold),
        ),
        for (final status in PedidoProdutoStatus.values)
          Builder(
            builder: (context) {
              double qtde = relatorioCtrl.getPedidosTotalPorStatus(status);
              return qtde <= 0
                  ? const SizedBox()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: itemInfo(
                            status.label,
                            qtde.toKg(),
                            color: status.color.withValues(alpha: 0.06),
                          ),
                        ),
                        const Divisor(),
                      ],
                    );
            },
          ),
        Divisor(color: Colors.grey[700]!, height: 1.5),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Totais por bitola:', style: AppCss.mediumBold),
        ),
        const Divisor(),
        for (final produto in FirestoreClient.produtos.data)
          Builder(
            builder: (context) {
              bool hasQtde = PedidoProdutoStatus.values
                  .map(
                    (e) => relatorioCtrl.getPedidosTotalPorBitolaStatus(
                      produto,
                      e,
                    ),
                  )
                  .toList()
                  .any((e) => e > 0);
              return !hasQtde
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemInfo(
                          'Bitola ${produto.descricaoReplaced}mm',
                          relatorioCtrl
                              .getPedidosTotalPorBitola(produto)
                              .toKg(),
                          labelStyle: AppCss.minimumBold,
                          valueStyle: AppCss.minimumBold,
                          padding: const EdgeInsets.all(16),
                        ),
                        for (final status in PedidoProdutoStatus.values)
                          Builder(
                            builder: (context) {
                              double qtde = relatorioCtrl
                                  .getPedidosTotalPorBitolaStatus(
                                    produto,
                                    status,
                                  );
                              return qtde <= 0
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: itemInfo(
                                            status.label,
                                            qtde.toKg(),
                                            color: status.color.withValues(
                                              alpha: 0.06,
                                            ),
                                          ),
                                        ),
                                        const Divisor(),
                                      ],
                                    );
                            },
                          ),
                        Divisor(color: Colors.grey[600]!),
                      ],
                    );
            },
          ),
      ],
    );
  }

  Widget itemRelatorio(PedidoModel pedido) {
    if (pedido.produtos.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[700]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(pedido.localizador, style: AppCss.mediumBold),
              ),
              Text(
                DateFormat(
                  "'Criado 'dd/MM/yyyy' às 'HH:mm",
                ).format(pedido.createdAt),
                style: AppCss.minimumRegular.setSize(11),
              ),
            ],
          ),
          const Divisor(),
          itemInfo('Cliente', pedido.cliente.nome),
          const Divisor(),
          itemInfo('Descrição', pedido.descricao),
          const Divisor(),
          itemInfo(
            'Data de Entrega',
            pedido.deliveryAt != null
                ? pedido.deliveryAt.text()
                : 'Não definida',
          ),
          const Divisor(),
          itemInfo('Tipo', pedido.tipo.label),
          const Divisor(),
          for (final produto in pedido.produtos)
            Column(
              children: [
                itemInfo(
                  '${produto.produto.descricaoReplaced}mm',
                  '(${produto.status.status.label}) ${produto.qtde}Kg',
                  color: produto.status.status.color.withValues(alpha: 0.06),
                ),
                Divisor(color: Colors.grey[300]),
              ],
            ),
          Divisor(color: Colors.grey[300]),
          itemInfo(
            'Total de Kgs',
            pedido.getQtdeTotal().toKg(),
            valueStyle: AppCss.mediumBold.copyWith(fontSize: 16),
            labelStyle: AppCss.mediumBold.copyWith(fontSize: 16),
            padding: EdgeInsets.only(top: 8),
          ),
        ],
      ),
    );
  }

  Widget itemInfo(
    String label,
    String value, {
    Color? color,
    TextStyle? labelStyle,
    EdgeInsets? padding,
    TextStyle? valueStyle,
  }) {
    return Container(
      color: color,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '$label:',
                style:
                    labelStyle ??
                    AppCss.minimumRegular.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: valueStyle ?? AppCss.minimumRegular.copyWith(),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
