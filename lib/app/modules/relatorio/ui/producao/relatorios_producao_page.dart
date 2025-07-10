import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
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
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_producao_view_model.dart';
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
            if (model.relatorio != null || model.relatorio!.ordens.isNotEmpty) ...[
              itemInfo(
                'Tempo de produção',
                relatorioCtrl.getOrdensTempoProducao(model.relatorio!.ordens).text(),
                labelStyle: AppCss.mediumBold,
                valueStyle: AppCss.mediumBold,
                padding: const EdgeInsets.all(16),
              ),
              Divisor(color: Colors.grey[700]!),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Totais por Bitola', style: AppCss.mediumBold),
              ),
              const Divisor(),
              for (final produto in relatorioCtrl.getOrdemTotalTempoProduto())
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: itemInfo(produto.produto.descricao, relatorioCtrl.getOrdensTempPorBitola(produto.produto, model.relatorio!.ordens).text()),
                    ),
                    const Divisor(),
                  ],
                ),
            ],
            Divisor(color: Colors.grey[700]!),
            if (model.relatorio != null || model.relatorio!.ordens.isNotEmpty)
              Column(
                children: model.relatorio!.ordens
                    .map((e) => itemRelatorio(model, e))
                    .toList(),
              ),
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

  Widget itemRelatorio(RelatorioProducaoViewModel model, OrdemModel ordem) {
    final durations = ordem.durations;
    if (durations == null) return const SizedBox.shrink();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ordem.localizator, style: AppCss.mediumBold),
                    if (ordem.materiaPrima != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${ordem.materiaPrima!.fabricanteModel.nome} - ${ordem.materiaPrima!.corridaLote}',
                          style: AppCss.minimumRegular,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ordem.status.color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ordem.status.label,
                  style: AppCss.minimumRegular
                      .setColor(ordem.status.color)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divisor(color: Colors.grey[200]),
          itemInfo('Iniciada em', durations.startedAt.textHour()),
          Divisor(color: Colors.grey[200]),
          itemInfo(
            'Concluida em',
            durations.endedAt?.textHour() ?? 'Não concluida',
          ),
          Divisor(color: Colors.grey[200]),
          itemInfo(
            'Tempo de produção',
            (durations.endedAt ?? DateTime.now())
                .difference(durations.startedAt)
                .text(),
          ),
          // for (final produto in ordem.produtos)
          //   Column(
          //     children: [
          //       itemInfo(
          //         '${produto.pedido.tipo.name.toUpperCase()} - ${produto.pedido.localizador} - ${produto.cliente.nome}${produto.obra.descricao == 'Indefinido' ? ' - ${produto.obra.descricao}' : ''}',
          //         produto.qtde.toKg(),
          //         color: produto.status.status.color.withValues(alpha: 0.06),
          //       ),
          //       if (produto.pedido.deliveryAt == null)
          //         Divisor(color: Colors.grey[200]),
          //       if (produto.pedido.deliveryAt != null) ...[
          //         itemInfo(
          //           'Previsão de Entrega',
          //           '${produto.pedido.deliveryAt?.text()}',
          //           color: produto.status.status.color.withValues(alpha: 0.06),
          //         ),
          //         Divisor(color: Colors.grey[200]),
          //       ],
          //       if (produto.materiaPrima != null &&
          //           produto.materiaPrima?.id != ordem.materiaPrima?.id) ...[
          //         itemInfo(
          //           'Materia Prima',
          //           '${produto.materiaPrima?.fabricanteModel.nome} - ${produto.materiaPrima?.corridaLote}',
          //         ),
          //         Divisor(color: Colors.grey[200]),
          //       ],
          //     ],
          //   ),
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
