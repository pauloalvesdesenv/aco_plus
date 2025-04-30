import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrdensConcluidasPage extends StatefulWidget {
  const OrdensConcluidasPage({super.key});

  @override
  State<OrdensConcluidasPage> createState() => _OrdensConcluidasPageState();
}

class _OrdensConcluidasPageState extends State<OrdensConcluidasPage> {
  @override
  void initState() {
    ordemCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Ordens Concluídas',
            style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          Tooltip(
            message: 'Filtro',
            child: IconButton(
                onPressed: () {
                  setState(() {
                    ordemCtrl.utilsConcluidas.showFilter =
                        !ordemCtrl.utilsConcluidas.showFilter;
                    ordemCtrl.utilsConcluidasStream.update();
                  });
                },
                icon: Icon(
                  Icons.sort,
                  color: AppColors.white,
                )),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<OrdemModel>>(
        stream: FirestoreClient.ordens.ordensArquivadasStream.listen,
        builder: (_, __) => StreamOut<OrdemConcluidasUtils>(
          stream: ordemCtrl.utilsConcluidasStream.listen,
          builder: (_, utilsConcluidas) {
            List<OrdemModel> ordens = ordemCtrl
                .getOrdensFiltered(utilsConcluidas.search.text,
                    __.where((e) => e.produtos.isNotEmpty).toList())
                .toList();
            if (utilsConcluidas.produto != null) {
              ordens = ordens
                  .where((e) => e.produto.id == utilsConcluidas.produto!.id)
                  .toList();
            }
            ordens.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return RefreshIndicator(
              onRefresh: () async => FirestoreClient.ordens.fetch(),
              child: ListView(
                children: [
                  if (utilsConcluidas.showFilter)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AppField(
                            label: 'Pesquisar',
                            controller: utilsConcluidas.search,
                            suffixIcon: Icons.search,
                            onChanged: (_) =>
                                ordemCtrl.utilsConcluidasStream.update(),
                          ),
                          const H(16),
                          AppDropDown<ProdutoModel?>(
                            label: 'Bitola',
                            item: utilsConcluidas.produto,
                            itens: FirestoreClient.produtos.data.toList(),
                            itemLabel: (e) => e != null
                                ? e.descricao
                                : 'Selecione um produto',
                            onSelect: (e) {
                              utilsConcluidas.produto = e;
                              ordemCtrl.utilsConcluidasStream.update();
                            },
                          ),
                        ],
                      ),
                    ),
                  ordens.isEmpty
                      ? const EmptyData()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          cacheExtent: 200,
                          itemCount: ordens.length,
                          itemBuilder: (_, i) => _itemOrdemWidget(ordens[i]),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemOrdemWidget(OrdemModel ordem) {
    return InkWell(
      key: ValueKey(ordem.id),
      onTap: () => push(OrdemPage(ordem.id)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ordem.localizator,
                      style: AppCss.mediumBold,
                    ),
                    Text(
                      '${ordem.produto.nome} ${ordem.produto.descricao} - ${ordem.produtos.fold(0.0, (previousValue, element) => previousValue + element.qtde).toKg()}',
                      style: AppCss.minimumRegular
                          .setSize(11)
                          .setColor(AppColors.black),
                    ),
                    Text(
                      'Criada ${ordem.createdAt.textHour()}',
                      style: AppCss.minimumRegular
                          .setSize(11)
                          .setColor(AppColors.neutralMedium),
                    ),
                  ],
                ),
              ),
              const W(8),
              if (ordem.produtos.isNotEmpty)
                Row(
                  children: [
                    _progressChartWidget(PedidoProdutoStatus.aguardandoProducao,
                        ordem.getPrcntgAguardando(), ordem.freezed.isFreezed),
                    const W(16),
                    _progressChartWidget(PedidoProdutoStatus.produzindo,
                        ordem.getPrcntgProduzindo(), ordem.freezed.isFreezed),
                    const W(16),
                    _progressChartWidget(PedidoProdutoStatus.pronto,
                        ordem.getPrcntgPronto(), ordem.freezed.isFreezed),
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
              const W(16),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.neutralMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressChartWidget(
      PedidoProdutoStatus status, double porcentagem, bool isFreezed) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: porcentagem,
          backgroundColor:
              (isFreezed ? Colors.grey[600]! : status.color).withOpacity(0.2),
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(
              isFreezed ? Colors.grey[600]! : status.color),
        ),
        Text(
          '${(porcentagem * 100).percent}%',
          style: AppCss.minimumBold.setSize(10),
        )
      ],
    );
  }
}
