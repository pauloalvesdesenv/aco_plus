import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
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
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordens_arquivadas_page.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrdensPage extends StatefulWidget {
  const OrdensPage({super.key});

  @override
  State<OrdensPage> createState() => _OrdensPageState();
}

class _OrdensPageState extends State<OrdensPage> {
  @override
  void initState() {
    ordemCtrl.onInit();
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
          'Ordens',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions:
            usuario.isOperador
                ? []
                : [
                  Tooltip(
                    message: 'Ordens Arquivadas',
                    child: IconButton(
                      onPressed:
                          () => push(context, const OrdensArquivadasPage()),
                      icon: Icon(
                        Icons.domain_verification,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Filtro',
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          ordemCtrl.utils.showFilter =
                              !ordemCtrl.utils.showFilter;
                          ordemCtrl.utilsStream.update();
                        });
                      },
                      icon: Icon(Icons.sort, color: AppColors.white),
                    ),
                  ),
                  if (usuario.permission.ordem.contains(
                    UserPermissionType.create,
                  ))
                    Tooltip(
                      message: 'Nova ordem',
                      child: IconButton(
                        onPressed: () => push(context, const OrdemCreatePage()),
                        icon: Icon(Icons.add, color: AppColors.white),
                      ),
                    ),
                ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<OrdemModel>>(
        stream: FirestoreClient.ordens.ordensNaoArquivadasStream.listen,
        builder:
            (_, __) => StreamOut<OrdemUtils>(
              stream: ordemCtrl.utilsStream.listen,
              builder: (_, utils) {
                List<OrdemModel> ordens =
                    ordemCtrl.getOrdensFiltered(utils.search.text, __).toList();
                if (utils.status.isNotEmpty) {
                  ordens =
                      ordens
                          .where((e) => utils.status.contains(e.status))
                          .toList();
                }
                if (utils.produto != null) {
                  ordens =
                      ordens
                          .where((e) => e.produto.id == utils.produto!.id)
                          .toList();
                }
                if (usuario.isOperador) {
                  ordens =
                      ordens
                          .where(
                            (e) => [
                              PedidoProdutoStatus.aguardandoProducao,
                              PedidoProdutoStatus.produzindo,
                              PedidoProdutoStatus.pronto,
                            ].contains(e.status),
                          )
                          .toList();
                }

                return RefreshIndicator(
                  onRefresh: () async => FirestoreClient.ordens.fetch(),
                  child: ListView(
                    children: [
                      if (utils.showFilter)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              AppField(
                                label: 'Pesquisar',
                                controller: utils.search,
                                suffixIcon: Icons.search,
                                onChanged:
                                    (_) => ordemCtrl.utilsStream.update(),
                              ),
                              const H(16),
                              AppDropDown<ProdutoModel?>(
                                label: 'Bitola',
                                item: utils.produto,
                                itens: FirestoreClient.produtos.data.toList(),
                                itemLabel:
                                    (e) =>
                                        e != null
                                            ? e.descricao
                                            : 'Selecione um produto',
                                onSelect: (e) {
                                  utils.produto = e;
                                  ordemCtrl.utilsStream.update();
                                },
                              ),
                              const H(16),
                              AppDropDownList<PedidoProdutoStatus>(
                                label: 'Ordernar por',
                                addeds: utils.status,
                                itens: const [
                                  PedidoProdutoStatus.aguardandoProducao,
                                  PedidoProdutoStatus.produzindo,
                                  PedidoProdutoStatus.pronto,
                                ],
                                itemLabel: (e) => e.label,
                                itemColor: (e) => e.color,
                                onChanged: () {
                                  ordemCtrl.utilsStream.update();
                                },
                              ),
                            ],
                          ),
                        ),
                      if (ordens.isEmpty) const EmptyData(),
                      if (ordens.isNotEmpty)
                        Builder(
                          builder: (_) {
                            final ordensNaoConcluidas =
                                ordens
                                    .where((e) => !e.freezed.isFreezed)
                                    .toList();
                            if (ordensNaoConcluidas.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: EmptyData(),
                              );
                            }
                            if (usuario.isOperador) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ordensNaoConcluidas.length,
                                itemBuilder:
                                    (_, i) => _itemOrdemWidget(
                                      ordensNaoConcluidas[i],
                                    ),
                              );
                            }
                            return ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              cacheExtent: 200,
                              itemCount: ordensNaoConcluidas.length,
                              onReorder: (oldIndex, newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex = newIndex - 1;
                                }
                                final step = ordensNaoConcluidas.removeAt(
                                  oldIndex,
                                );
                                ordensNaoConcluidas.insert(newIndex, step);
                                ordemCtrl.onReorder(ordensNaoConcluidas);
                              },
                              itemBuilder:
                                  (_, i) =>
                                      _itemOrdemWidget(ordensNaoConcluidas[i]),
                            );
                          },
                        ),
                      if (usuario.isNotOperador)
                        Builder(
                          builder: (_) {
                            final ordensCongeladas = ordemCtrl
                                .getOrdensFiltered(
                                  utils.search.text,
                                  FirestoreClient.ordens.ordensCongeladas,
                                );
                            ordensCongeladas.sort(
                              (a, b) => b.freezed.updatedAt.compareTo(
                                a.freezed.updatedAt,
                              ),
                            );
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              cacheExtent: 200,
                              itemCount: ordensCongeladas.length,
                              itemBuilder:
                                  (_, i) =>
                                      _itemOrdemWidget(ordensCongeladas[i]),
                            );
                          },
                        ),
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
        child: Stack(
          children: [
            Container(
              color: ordem.freezed.isFreezed ? Colors.grey[200]! : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(ordem.icon),
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
                        if (ordem.materiaPrima != null) ...[
                          Text(
                            ordem.materiaPrima!.label,
                            style: AppCss.minimumRegular
                                .setSize(11)
                                .setColor(AppColors.black),
                          ),
                        ],
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
            if (usuario.isNotOperador)
              if (!ordem.freezed.isFreezed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMain.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    ordem.beltIndex != null ? '${ordem.beltIndex! + 1}º' : '-',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[900]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

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
              .withOpacity(0.2),
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
