import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/type_selector_widget.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatoriosOrdemPage extends StatefulWidget {
  const RelatoriosOrdemPage({super.key});

  @override
  State<RelatoriosOrdemPage> createState() => _RelatoriosOrdemPageState();
}

class _RelatoriosOrdemPageState extends State<RelatoriosOrdemPage> {
  @override
  void initState() {
    relatorioCtrl.ordemViewModelStream.add(RelatorioOrdemViewModel());
    relatorioCtrl.onCreateRelatorio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        title: Text(
          'Relatórios de Ordem',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
        actions: [
          StreamOut(
            stream: relatorioCtrl.ordemViewModelStream.listen,
            builder: (_, model) => IconButton(
              onPressed: model.relatorio != null
                  ? () => relatorioCtrl.onExportRelatorioOrdemPDF()
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
        stream: relatorioCtrl.ordemViewModelStream.listen,
        builder: (_, model) => ListView(
          children: [
            _filterWidget(model),
            Divisor(color: Colors.grey[700]!, height: 1.5),
            if (model.type == RelatorioOrdemType.STATUS &&
                model.relatorio != null) ...[
              itemInfo(
                'Total Geral',
                relatorioCtrl.getOrdemTotal().toKg(),
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
              for (final produto in relatorioCtrl.getOrdemTotalProduto())
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: itemInfo(
                        produto.produto.descricao,
                        produto.qtde.toKg(),
                      ),
                    ),
                    const Divisor(),
                  ],
                ),
            ],
            Divisor(color: Colors.grey[700]!),
            if (model.relatorio != null)
              Column(
                children: [
                  if (model.type == RelatorioOrdemType.ORDEM)
                    model.relatorio!.ordem,
                  if (model.type == RelatorioOrdemType.STATUS)
                    ...model.relatorio!.ordens,
                ].map((e) => itemRelatorio(e)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Padding _filterWidget(RelatorioOrdemViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TypeSelectorWidget<RelatorioOrdemType?>(
            label: 'Selecione o modelo de relatório',
            values: RelatorioOrdemType.values,
            value: relatorioCtrl.ordemViewModel.type,
            onChanged: (e) {
              model.ordem = null;
              model.status = [];
              model.dates = null;
              model.relatorio = null;
              model.type = e;
              if (e == RelatorioOrdemType.STATUS) {
                model.status = [RelatorioOrdemStatus.AGUARDANDO_PRODUCAO];
              }
              relatorioCtrl.ordemViewModelStream.add(model);
            },
            itemLabel: (e) => e?.label ?? 'SELECIONE O MODELO',
          ),
          if (model.type == RelatorioOrdemType.ORDEM) ...{
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: AppField(
                    required: false,
                    label: 'Ordem única',
                    controller: model.ordemEC,
                    onEditingComplete: () => relatorioCtrl.onSearchRelatorio(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 23, left: 12),
                    child: AppTextButton(
                      label: 'Buscar',
                      onPressed: () => relatorioCtrl.onSearchRelatorio(),
                    ),
                  ),
                ),
              ],
            ),
            const H(16),
          },
          if (model.type == RelatorioOrdemType.STATUS) ...{
            AppDropDownList<RelatorioOrdemStatus?>(
              label: 'Status',
              addeds: model.status,
              itens: RelatorioOrdemStatus.values,
              itemLabel: (e) => e?.label ?? 'SELECIONE O STATUS',
              itemColor: (e) =>
                  e?.color.withValues(alpha: 0.4) ?? Colors.transparent,
              onChanged: () {
                relatorioCtrl.ordemViewModelStream.add(model);
                relatorioCtrl.onCreateRelatorio();
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
                relatorioCtrl.ordemViewModelStream.update();
                relatorioCtrl.onCreateRelatorio();
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
                            relatorioCtrl.onExportRelatorioPedidoPDF(
                              relatorioCtrl.pedidoViewModel,
                            );
                            relatorioCtrl.ordemViewModelStream.update();
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
          },
        ],
      ),
    );
  }

  Widget itemRelatorio(OrdemModel ordem) {
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
              Text(
                DateFormat(
                  "'Criado 'dd/MM/yyyy' às 'HH:mm",
                ).format(ordem.createdAt),
                style: AppCss.minimumRegular.setSize(11),
              ),
            ],
          ),
          itemInfo(
            'Bitola ${ordem.produto.descricaoReplaced}mm',
            ordem.produtos.map((e) => e.qtde).fold(0.0, (a, b) => a + b).toKg(),
            labelStyle: AppCss.minimumRegular.copyWith(
              fontWeight: FontWeight.w600,
            ),
            valueStyle: AppCss.minimumRegular.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divisor(),
          for (final produto in ordem.produtos)
            Column(
              children: [
                itemInfo(
                  '${produto.pedido.localizador} - ${produto.cliente.nome}${produto.obra.descricao == 'Indefinido' ? ' - ${produto.obra.descricao}' : ''}',
                  produto.qtde.toKg(),
                  color: produto.status.status.color.withValues(alpha: 0.06),
                ),
                Divisor(color: Colors.grey[200]),
              ],
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
