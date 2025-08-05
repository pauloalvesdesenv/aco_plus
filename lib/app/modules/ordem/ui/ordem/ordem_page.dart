import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/item_label.dart';
import 'package:aco_plus/app/core/components/row_itens_label.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materia_prima_bottom.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/ordem_status_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/produto/ordem_pedido_produto_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/timeline/ordem_timeline_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_exportar_pdf_tipo_bottom.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class OrdemPage extends StatefulWidget {
  final String ordemId;
  const OrdemPage(this.ordemId, {super.key});

  @override
  State<OrdemPage> createState() => _OrdemPageState();
}

class _OrdemPageState extends State<OrdemPage> {
  @override
  void initState() {
    setWebTitle('Ordem');
    ordemCtrl.onInitPage(widget.ordemId);
    super.initState();
  }

  @override
  void dispose() {
    ordemCtrl.onDisposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: FirestoreClient.materiaPrimas.dataStream.listen,
      builder: (_, materiasPrimas) => StreamOut(
        stream: FirestoreClient.pedidos.dataStream.listen,
        builder: (_, pedidos) => StreamOut(
          stream: ordemCtrl.ordemStream.listen,
          builder: (_, ordem) => AppScaffold(
            resizeAvoid: true,
            appBar: AppBar(
              actions: usuario.isOperador
                  ? []
                  : [
                      if (!ordem.isArchived)
                        IconButton(
                          onPressed: () async =>
                              ordemCtrl.onArchive(context, ordem),
                          icon: Icon(Icons.archive, color: AppColors.white),
                        ),
                      if (ordem.isArchived)
                        IconButton(
                          onPressed: () async =>
                              ordemCtrl.onUnarchive(context, ordem, 2),
                          icon: Icon(Icons.unarchive, color: AppColors.white),
                        ),
                      IconButton(
                        onPressed: () async {
                          final tipo = await showOrdemExportarPdfTipoBottom();
                          if (tipo != null) {
                            if (tipo == OrdemExportarPdfTipo.relatorio) {
                              await ordemCtrl.onGenerateRelatorioPDF(ordem);
                            } else {
                              await ordemCtrl.onGenerateEtiquetasPDF(ordem);
                            }
                          }
                        },
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: AppColors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () async =>
                            push(context, OrdemCreatePage(ordem: ordem)),
                        icon: Icon(Icons.edit, color: AppColors.white),
                      ),
                      IconButton(
                        onPressed: () async =>
                            ordemCtrl.onDelete(context, ordem),
                        icon: Icon(Icons.delete, color: AppColors.white),
                      ),
                    ],
              title: Text(
                'Ordem ${ordem.localizator}',
                style: AppCss.largeBold.setColor(AppColors.white),
              ),
              backgroundColor: AppColors.primaryMain,
            ),
            body: StreamOut(
              stream: ordemCtrl.ordemStream.listen,
              builder: (_, form) => body(pedidos, form),
            ),
          ),
        ),
      ),
    );
  }

  Widget body(List<PedidoModel> pedidos, OrdemModel ordem) {
    return RefreshIndicator(
      onRefresh: () async {
        await FirestoreClient.ordens.fetch();
        ordemCtrl.getOrdemById(widget.ordemId);
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (ordem.freezed.isFreezed) unfreezedWidget(ordem),
          Container(
            color: ordem.freezed.isFreezed
                ? Colors.grey.withValues(alpha: 0.1)
                : null,
            child: Column(
              children: [
                _descriptionWidget(ordem),
                if (ordem.history.isNotEmpty) const Divisor(),
                if (ordem.history.isNotEmpty) OrdemTimelineWidget(ordem: ordem),
                const Divisor(),
                OrdemStatusWidget(ordem: ordem),
                for (final produto in ordem.produtos)
                  OrdemPedidoProdutoWidget(
                    produto: produto,
                    ordem: ordem,
                    materiaPrima: ordemCtrl.getMateriaPrimaByPedidoProduto(
                      pedidos,
                      produto,
                    ),
                  ),
                if (usuario.isNotOperador)
                  if (!ordem.freezed.isFreezed &&
                      ordem.status != PedidoProdutoStatus.pronto)
                    _freezedWidget(ordem),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _descriptionWidget(OrdemModel ordem) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowItensLabel([
            ItemLabel(
              'Produto',
              '${ordem.produto.nome} - ${ordem.produto.descricao}',
            ),
            ItemLabel('Iniciada', ordem.createdAt.text()),
            if (ordem.endAt != null)
              ItemLabel('Finalizada', ordem.endAt.text()),
          ]),
          const H(16),
          InkWell(
            onTap: () async {
              if (ordem.materiaPrima == null) return;
              final result = await showMateriaPrimaBottom(ordem.materiaPrima!);
              if (result != null) {
                push(context, MateriaPrimaCreatePage(materiaPrima: result));
              }
            },
            child: ItemLabel(
              'Matéria Prima',
              ordem.materiaPrima != null
                  ? ordem.materiaPrima!.label
                  : 'Não especificado',
            ),
          ),
        ],
      ),
    );
  }

  Widget _freezedWidget(OrdemModel ordem) {
    return Column(
      children: [
        const Divisor(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.stop_circle_outlined),
                  const W(8),
                  Expanded(
                    child: Text('Congelar Ordem', style: AppCss.largeBold),
                  ),
                ],
              ),
              const H(8),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: AppField(
                      label: 'Motivo do Congelamento',
                      required: false,
                      controller: ordem.freezed.reason,
                      onChanged: (e) => ordemCtrl.ordemStream.update(),
                    ),
                  ),
                  const W(8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 26),
                      child: AppTextButton(
                        label: 'Confirmar',
                        onPressed: () async =>
                            await ordemCtrl.onFreezed(context, ordem),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget unfreezedWidget(OrdemModel ordem) {
    return Column(
      children: [
        const Divisor(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.stop_circle_outlined),
                  const W(12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ordem Congelada', style: AppCss.largeBold),
                        Text(
                          'Congelada ás ${ordem.freezed.updatedAt.textHour()}',
                          style: AppCss.minimumRegular.copyWith(
                            color: AppColors.black.withValues(alpha: 0.6),
                            fontSize: 12,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AppTextButton(
                      label: 'Descongelar Ordem',
                      onPressed: () async =>
                          await ordemCtrl.onFreezed(context, ordem),
                    ),
                  ),
                ],
              ),
              const H(16),
              ItemLabel('Motivo', ordem.freezed.reason.text),
            ],
          ),
        ),
      ],
    );
  }
}
