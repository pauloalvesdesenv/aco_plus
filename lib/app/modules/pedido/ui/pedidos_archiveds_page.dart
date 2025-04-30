import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:flutter/material.dart';

class PedidosArchivedsPage extends StatefulWidget {
  const PedidosArchivedsPage({super.key});

  @override
  State<PedidosArchivedsPage> createState() => _PedidoArchivedsPageState();
}

class _PedidoArchivedsPageState extends State<PedidosArchivedsPage> {
  @override
  void initState() {
    pedidoCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Pedidos Arquivados',
            style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  pedidoCtrl.utilsArquiveds.showFilter =
                      !pedidoCtrl.utilsArquiveds.showFilter;
                  pedidoCtrl.utilsArquivedsStream.update();
                });
              },
              icon: Icon(
                Icons.sort,
                color: AppColors.white,
              )),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<PedidoModel>>(
        stream: FirestoreClient.pedidos.pedidosArchivedsStream.listen,
        builder: (_, pedidos) => StreamOut<PedidoArquivedUtils>(
          stream: pedidoCtrl.utilsArquivedsStream.listen,
          builder: (_, utils) {
            pedidos = pedidoCtrl
                .getPedidosArchivedsFiltered(
                    utils.search.text,
                    FirestoreClient.pedidos.pedidosArchiveds
                        .map((e) => e.copyWith())
                        .toList())
                .toList();
            return Column(
              children: [
                if (utils.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AppField(
                          hint: 'Pesquisar',
                          controller: utils.search,
                          suffixIcon: Icons.search,
                          onChanged: (_) =>
                              pedidoCtrl.utilsArquivedsStream.update(),
                        ),
                        const H(16),
                        AppDropDownList<StepModel>(
                          label: 'Etapas',
                          itemColor: (e) => e.color,
                          itens: FirestoreClient.steps.data,
                          addeds: utils.steps,
                          itemLabel: (e) => e.name,
                          onChanged: () {
                            pedidoCtrl.utilsArquivedsStream.update();
                          },
                        ),
                        const H(16),
                        Row(
                          children: [
                            Expanded(
                              child: AppDropDown<SortType>(
                                label: 'Ordernar por',
                                hasFilter: false,
                                item: utils.sortType,
                                itens: const [
                                  SortType.createdAt,
                                  SortType.deliveryAt,
                                  SortType.localizator,
                                  SortType.client
                                ],
                                itemLabel: (e) => e.name,
                                onSelect: (e) {
                                  utils.sortType = e ?? SortType.localizator;
                                  pedidoCtrl.utilsArquivedsStream.update();
                                },
                              ),
                            ),
                            const W(16),
                            Expanded(
                              child: AppDropDown<SortOrder>(
                                hasFilter: false,
                                label: 'Ordernar',
                                item: utils.sortOrder,
                                itens: SortOrder.values,
                                itemLabel: (e) => e.name,
                                onSelect: (e) {
                                  utils.sortOrder = e ?? SortOrder.asc;
                                  pedidoCtrl.utilsArquivedsStream.update();
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: pedidos.isEmpty
                      ? const SizedBox(
                          width: double.maxFinite, child: EmptyData())
                      : RefreshIndicator(
                          onRefresh: () async =>
                              await FirestoreClient.pedidos.fetch(),
                          child: ListView.separated(
                            itemCount: pedidos.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemPedidoWidget(pedidos[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _itemPedidoWidget(PedidoModel pedido) {
    return Container(
      color: Colors.grey.withOpacity(0.07),
      child: InkWell(
        // onTap: () => pedidoCtrl.onUnArchivePedido(context, pedido),
        onTap: () => push(
            context, PedidoPage(pedido: pedido, reason: PedidoInitReason.page)),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.neutralLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pedido.localizador,
                          style: AppCss.mediumBold,
                        ),
                        Text(
                          '${pedido.cliente.nome} - ${pedido.obra.descricao}',
                        ),
                        Text(
                          pedido.produtos
                              .map((e) =>
                                  '${'${e.produto.descricao} - ${e.qtde}'}Kg')
                              .join(', '),
                          style: AppCss.minimumRegular
                              .setSize(11)
                              .setColor(AppColors.black),
                        ),
                        if (pedido.deliveryAt != null)
                          Text(
                            'Previsão de Entrega: ${pedido.deliveryAt.text()}',
                            style: AppCss.minimumRegular
                                .setSize(13)
                                .setColor(AppColors.neutralDark)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                  const W(8),
                  IconLoadingButton(
                      () async =>
                          await pedidoCtrl.onUnArchivePedido(context, pedido),
                      icon: Icons.unarchive_outlined),
                  const W(16),
                  _progressChartWidget(PedidoProdutoStatus.aguardandoProducao,
                      pedido.getPrcntgAguardandoProducao()),
                  const W(16),
                  _progressChartWidget(PedidoProdutoStatus.produzindo,
                      pedido.getPrcntgProduzindo()),
                  const W(16),
                  _progressChartWidget(
                      PedidoProdutoStatus.pronto, pedido.getPrcntgPronto()),
                  const W(16),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.neutralMedium,
                  ),
                ],
              ),
            ),
            if (pedido.steps.isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(0.5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: pedido.step.color.withOpacity(0.15),
                  ),
                  child: Text(
                    pedido.steps.last.step.name,
                    style: AppCss.minimumBold
                        .setSize(9)
                        .setColor(Colors.grey[800]!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _progressChartWidget(PedidoProdutoStatus status, double porcentagem) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: porcentagem,
          backgroundColor: status.color.withOpacity(0.2),
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(status.color),
        ),
        Text(
          '${(porcentagem * 100).percent}%',
          style: AppCss.minimumBold.setSize(10),
        )
      ],
    );
  }
}
