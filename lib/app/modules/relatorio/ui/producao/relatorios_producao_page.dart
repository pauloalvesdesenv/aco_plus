import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/duration_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/ui/components/relatorio_expandable_widget.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_producao_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoriosProducaoPage extends StatefulWidget {
  const RelatoriosProducaoPage({super.key});

  @override
  State<RelatoriosProducaoPage> createState() => _RelatoriosProducaoPageState();
}

class _RelatoriosProducaoPageState extends State<RelatoriosProducaoPage> {
  @override
  void initState() {
    setWebTitle('Relatórios de Produção');
    relatorioCtrl.producaoViewModelStream.add(
      RelatorioProducaoViewModel.create(),
    );
    relatorioCtrl.onCreateRelatorioProducao();
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
          'Relatórios de Produção',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.producaoViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed: model.relatorio != null
                  ? () async {
                      relatorioCtrl.onExportRelatorioProducaoPDF(
                        model.relatorio!,
                      );
                    }
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
        stream: relatorioCtrl.producaoViewModelStream.listen,
        builder: (_, model) => ListView(
          children: [
            _filterWidget(model),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            _itemTotalWidget(model),
          ],
        ),
      ),
    );
  }

  Padding _filterWidget(RelatorioProducaoViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppDropDownList<ProdutoModel?>(
            label: 'Produtos',
            addeds: model.produtos,
            itens: FirestoreClient.produtos.data,
            itemLabel: (e) => e?.descricao ?? 'SELECIONE O PRODUTO',
            itemColor: (e) => Colors.white,
            onChanged: () {
              relatorioCtrl.producaoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioProducao();
            },
          ),
          const H(16),
          InkWell(
            onTap: () async {
              final dates = await showDateRangePicker(
                context: contextGlobal,
                firstDate: DateTime(2010),
                lastDate: DateTime(2030),
              );
              if (dates == null) return;
              model.dates = dates;
              relatorioCtrl.producaoViewModelStream.update();
              relatorioCtrl.onCreateRelatorioProducao();
              setState(() {});
            },
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: AppField(
                    required: false,
                    label: 'Datas: (Opcional)',
                    controller: TextController(
                      text: model.dates != null
                          ? ([model.dates!.start, model.dates!.end]
                                .map((e) => DateFormat('dd/MM/yyy').format(e))
                                .join(' até '))
                          : 'Selecione',
                    ),
                  ),
                ),
                if (model.dates != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.only(top: 26),
                      child: IconButton(
                        onPressed: () {
                          model.dates = null;
                          relatorioCtrl.onCreateRelatorioProducao();
                          relatorioCtrl.producaoViewModelStream.update();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        icon: Icon(Icons.close, color: Colors.grey[500]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const H(16),
          AppField(
            label: 'Localizador',
            controller: model.localizadorEC,
            onChanged: (e) {
              relatorioCtrl.producaoViewModelStream.add(model);
              relatorioCtrl.onCreateRelatorioProducao();
            },
          ),
        ],
      ),
    );
  }

  Widget _itemTotalWidget(RelatorioProducaoViewModel model) {
    return Column(
      children: [
        itemInfo(
          'Total',
          relatorioCtrl.getTempoProducao(model.relatorio!.turnos).text(),
          valueStyle: AppCss.minimumBold.copyWith(fontSize: 16),
          labelStyle: AppCss.minimumBold.copyWith(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        Divisor(color: Colors.grey[700]!, height: 1.5),
        for (final produto in model.produtos)
          _itemProdutoWidget(
            model.relatorio!.turnos,
            produto,
            model.relatorio!.ordens,
          ),
      ],
    );
  }

  Widget _itemProdutoWidget(
    List<PedidoProdutoTurno> turnos,
    ProdutoModel produto,
    List<OrdemModel> ordens,
  ) {
    return RelatorioExpandableWidget(
      title: 'Produto ${produto.descricao}',
      value: relatorioCtrl
          .getTempoProducao(
            turnos.where((e) => e.produtoId == produto.id).toList(),
          )
          .text(),
      color: Colors.grey[100]!,
      children: ordens.map((e) => _itemOrdemWidget(turnos, e)).toList(),
    );
  }

  Widget _itemOrdemWidget(List<PedidoProdutoTurno> turnos, OrdemModel ordem) {
    return RelatorioExpandableWidget(
      title: 'Ordem ${ordem.localizator}',
      value: relatorioCtrl
          .getTempoProducao(
            turnos.where((e) => e.ordemId == ordem.id).toList(),
          )
          .text(),
      color: Colors.grey[200]!,
      children: ordem.produtos
          .map((e) => _itemPedidoProdutoWidget(turnos, ordem, e))
          .toList(),
    );
  }

  Widget _itemPedidoProdutoWidget(
    List<PedidoProdutoTurno> turnos,
    OrdemModel ordem,
    PedidoProdutoModel pedidoProduto,
  ) {
    return RelatorioExpandableWidget(
      title: 'Pedido ${pedidoProduto.pedido.localizador}',
      value: relatorioCtrl
          .getTempoProducao(
            turnos.where((e) => e.pedidoProdutoId == pedidoProduto.id).toList(),
          )
          .text(),
      color: Colors.grey[300]!,
      children: pedidoProduto
          .getTurnos(ordem)
          .mapIndexed(
            (index, e) => _itemPedidoProdutoTurnoWidget(e, index),
          )
          .toList(),
    );
  }

  Widget _itemPedidoProdutoTurnoWidget(
    PedidoProdutoTurno turno,
    int index,
  ) {
    return RelatorioExpandableWidget(
      color: Colors.grey[400]!,
      title: 'Turno ${index + 1}',
      value: relatorioCtrl
          .getTempoProducao(
            [turno],
          )
          .text(),
      children: [_itemPedidoProdutoTurnoHistoryWidget(turno)],
    );
  }

  Widget _itemPedidoProdutoTurnoHistoryWidget(PedidoProdutoTurno turno) {
    return Column(
      children: [
        itemInfo(turno.start.type.label, turno.start.date.textHour()),
        Divisor(color: Colors.grey[700]!),
        itemInfo(
          turno.end?.type.label ?? 'Em produção',
          (turno.end?.date ?? DateTime.now()).textHour(),
        ),
      ],
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
                label,
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
