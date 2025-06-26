import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_prioridade_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/drawer/app_drawer.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/dashboard/dashboard_controller.dart';
import 'package:aco_plus/app/modules/dashboard/ui/dashboard_pedido_prioridade_bottom.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_widget.dart';
import 'package:aco_plus/app/modules/graph/pedido_etapa/pedido_etapa_widget.dart';
import 'package:aco_plus/app/modules/graph/pedido_status/pedido_status_widget.dart';
import 'package:aco_plus/app/modules/graph/produto_produzido/produto_produzido_widget.dart';
import 'package:aco_plus/app/modules/graph/produto_status/produto_status_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    setWebTitle('Dashboard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Dashboard',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
      ),
      body: body(),
    );
  }

  Widget body() {
    return StreamOut(
      stream: FirestoreClient.pedidos.pedidosUnarchivedsStream.listen,
      builder: (_, pedidos) => StreamOut(
        stream: FirestoreClient.ordens.dataStream.listen,
        builder: (_, __) => StreamOut(
          stream: dashCtrl.utilsStream.listen,
          builder: (_, utils) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return ListView(
                  children: [
                    Column(
                      children: [
                        _graficoOrdemStatus(),
                        const Divisor(),
                        _graficoPedidoStatus(),
                        const Divisor(),
                        _graficoPedidoEtapa(),
                        const Divisor(),
                        _graficoProdutosStatus(),
                        const Divisor(),
                        _graficoProdutoProduzido(),
                        const Divisor(),
                      ],
                    ),
                  ],
                );
              } else {
                return ListView(
                  children: [
                    _pedidoPrioridadeWidget(),
                    const Divisor(),
                    _ordemProducaoWidget(),
                    const Divisor(),
                    Row(
                      children: [
                        Expanded(child: _graficoOrdemStatus()),
                        Expanded(child: _graficoPedidoStatus()),
                        Expanded(child: _graficoPedidoEtapa()),
                      ],
                    ),
                    const Divisor(),
                    Row(
                      children: [
                        Expanded(child: _graficoProdutosStatus()),
                        Expanded(child: _graficoProdutoProduzido()),
                      ],
                    ),
                    const Divisor(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _graficoPedidoEtapa() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 360,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 32),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEDIDOS POR ETAPA',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos dos pedidos separados por etapas',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24),
            ],
          ),
          const H(8),
          const Expanded(child: PedidoEtapaWidget()),
        ],
      ),
    );
  }

  Widget _graficoPedidoStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 360,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 32),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEDIDOS POR STATUS',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos dos pedidos separados por status',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24),
            ],
          ),
          const H(8),
          const Expanded(child: PedidoStatusWidget()),
        ],
      ),
    );
  }

  Widget _graficoOrdemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 360,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, size: 32),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDENS POR STATUS',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos das ordens de produção separados por status',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24),
            ],
          ),
          const H(8),
          const Expanded(child: GraphOrdemTotalWidget()),
        ],
      ),
    );
  }

  Widget _graficoProdutosStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, size: 32),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BITOLAS POR STATUS',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos de bitolas separados por status',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24),
            ],
          ),
          const H(8),
          const Expanded(child: ProdutoStatusWidget()),
        ],
      ),
    );
  }

  Widget _graficoProdutoProduzido() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, width: 0.8),
          left: BorderSide(color: Colors.grey[200]!, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.line_axis, size: 32),
              const W(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KILOS PRODUZIDOS POR DIA',
                      style: AppCss.largeBold.setSize(22).setHeight(1.2),
                    ),
                    Text(
                      'Total em kilos de bitolas separados por dias',
                      style: AppCss.mediumRegular.setSize(13).setHeight(1.2),
                    ),
                  ],
                ),
              ),
              const W(24),
            ],
          ),
          const H(8),
          const Expanded(child: ProdutoProduzidoWidget()),
        ],
      ),
    );
  }

  Widget _pedidoPrioridadeWidget() => StreamOut<List<PedidoModel>>(
    stream: FirestoreClient.pedidos.pedidosPrioridadeStream.listen,
    builder: (_, pedidos) {
      final isPrioridadeEmpty = pedidos.isEmpty;
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPrioridadeEmpty ? null : Colors.orange,
                      border: Border.all(
                        color: isPrioridadeEmpty
                            ? Colors.grey[200]!
                            : Colors.black,
                        width: 0.8,
                      ),
                    ),
                    child: isPrioridadeEmpty
                        ? Icon(
                            Icons.priority_high,
                            size: 14,
                            color: Colors.grey[200],
                          )
                        : Text(
                            pedidos.length.toString(),
                            style: AppCss.minimumRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                  ),
                  Gap(8),
                  Text('Fila de Prioridades:', style: AppCss.largeBold),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: PedidoPrioridadeTipo.values.map((tipo) {
                final pedidosPorFiltro = pedidos
                    .where((element) => element.prioridade!.tipo == tipo)
                    .toList();
                return Expanded(
                  child: Container(
                    width: double.maxFinite,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[200]!, width: 0.8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: pedidosPorFiltro.isEmpty
                                ? null
                                : Colors.orange.withValues(alpha: 0.3),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Gap(8),
                              Icon(tipo.getIcon(), size: 18),
                              W(16),
                              Expanded(
                                child: Text(
                                  tipo.getLabel(),
                                  style: AppCss.mediumBold,
                                ),
                              ),
                              W(16),
                              InkWell(
                                onTap: () async {
                                  final result =
                                      await showDashboardPedidoPrioridadeBottom(
                                        tipo,
                                        pedidosPorFiltro,
                                      );
                                  if (result != null) {
                                    dashCtrl.onReorderPrioridade(result);
                                  }
                                },
                                child: Icon(
                                  Icons.fullscreen,
                                  color: Colors.grey[600],
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: pedidosPorFiltro.isEmpty
                                ? null
                                : Colors.orange.withValues(alpha: 0.1),
                            child: Builder(
                              builder: (context) {
                                if (pedidosPorFiltro.isEmpty) {
                                  return const SizedBox();
                                }
                                pedidosPorFiltro.sort(
                                  (a, b) => a.prioridade!.index.compareTo(
                                    b.prioridade!.index,
                                  ),
                                );
                                return ListView.builder(
                                  itemCount: pedidosPorFiltro.length,
                                  itemBuilder: (_, i) =>
                                      _pedidoPrioridadeItemWidget(
                                        i,
                                        pedidosPorFiltro[i],
                                      ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );

  Widget _pedidoPrioridadeItemWidget(int index, PedidoModel pedido) {
    return InkWell(
      onTap: () =>
          push(PedidoPage(pedido: pedido, reason: PedidoInitReason.page)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.8),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Gap(8),
            Text('${index + 1}º', style: AppCss.mediumBold),
            Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pedido.localizador.trim(), style: AppCss.mediumBold),
                  Text(
                    pedido.produtos
                        .map((e) => '${'${e.produto.descricao} - ${e.qtde}'}Kg')
                        .join(', '),
                    overflow: TextOverflow.fade,
                    style: AppCss.minimumRegular
                        .setSize(11)
                        .setColor(AppColors.black)
                        .copyWith(overflow: TextOverflow.fade),
                  ),
                ],
              ),
            ),
            Gap(16),
            Icon(Symbols.arrow_forward_ios, size: 10, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _ordemProducaoWidget() => StreamOut<List<OrdemModel>>(
    stream: FirestoreClient.ordens.ordensNaoArquivadasStream.listen,
    builder: (_, ordens) {
      List<OrdemModel> ordensFiltradas = ordens.toList();
      ordensFiltradas.removeWhere((element) => element.freezed.isFreezed);
      ordensFiltradas = ordensFiltradas
          .where((element) => element.status != PedidoProdutoStatus.pronto)
          .toList();

      return Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Esteira de Produção:', style: AppCss.largeBold),
                  Text(
                    '${ordensFiltradas.length} Ordens (Apenas Aguardando Produção e Produzindo)',
                    textAlign: TextAlign.center,
                    style: AppCss.minimumRegular.setSize(12),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.maxFinite,
              height: 250,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey[200]!, width: 0.8),
                ),
              ),
              child: ListView.builder(
                itemCount: ordensFiltradas.length,
                itemBuilder: (_, i) =>
                    _ordemProducaoItemWidget(context, ordensFiltradas[i]),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _ordemProducaoItemWidget(
    BuildContext context,
    OrdemModel ordem,
  ) => InkWell(
    onTap: () => push(OrdemPage(ordem.id)),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFC),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Stack(
        children: [
          Container(
            color: ordem.freezed.isFreezed
                ? Colors.grey[200]!
                : const Color(0xFFF8FCFC),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  ordem.beltIndex != null ? '${ordem.beltIndex! + 1}º' : '-',
                  style: AppCss.mediumBold,
                ),
                const W(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ordem.localizator, style: AppCss.mediumBold),
                      Text(
                        '${ordem.produto.nome} ${ordem.produto.descricao} - ${ordem.produtos.fold(0.0, (previousValue, element) => previousValue + element.qtde).toKg()}',
                        style: AppCss.minimumRegular
                            .setSize(11)
                            .setColor(AppColors.black),
                      ),
                    ],
                  ),
                ),
                const W(8),
                if (ordem.produtos.isNotEmpty)
                  Row(
                    children: [
                      _progressChartWidget(
                        PedidoProdutoStatus.aguardandoProducao,
                        ordem.getPrcntgAguardando(),
                        ordem.freezed.isFreezed,
                      ),
                      const W(16),
                      _progressChartWidget(
                        PedidoProdutoStatus.produzindo,
                        ordem.getPrcntgProduzindo(),
                        ordem.freezed.isFreezed,
                      ),
                      const W(16),
                      _progressChartWidget(
                        PedidoProdutoStatus.pronto,
                        ordem.getPrcntgPronto(),
                        ordem.freezed.isFreezed,
                      ),
                    ],
                  ),
                if (ordem.produtos.isEmpty)
                  const Row(
                    children: [
                      Text('Ordem Vazia'),
                      W(8),
                      Icon(Symbols.brightness_empty),
                    ],
                  ),
                const W(32),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _progressChartWidget(
    PedidoProdutoStatus status,
    double porcentagem,
    bool isFreezed,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: porcentagem,
          backgroundColor: (isFreezed ? Colors.grey[600]! : status.color)
              .withValues(alpha: 0.2),
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
            isFreezed ? Colors.grey[600]! : status.color,
          ),
        ),
        Text(
          '${(porcentagem * 100).percent}%',
          style: AppCss.minimumBold.setSize(10),
        ),
      ],
    );
  }
}
