import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
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
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/components/timeline/ordem_timeline_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_exportar_pdf_tipo_bottom.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class OrdemPage extends StatefulWidget {
  final String ordemId;
  const OrdemPage(this.ordemId, {super.key});

  @override
  State<OrdemPage> createState() => _OrdemPageState();
}

class _OrdemPageState extends State<OrdemPage> {
  @override
  void initState() {
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
                    icon: Icon(Icons.picture_as_pdf, color: AppColors.white),
                  ),
                  IconButton(
                    onPressed: () async =>
                        push(context, OrdemCreatePage(ordem: ordem)),
                    icon: Icon(Icons.edit, color: AppColors.white),
                  ),
                  IconButton(
                    onPressed: () async => ordemCtrl.onDelete(context, ordem),
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
          builder: (_, form) => body(form),
        ),
      ),
    );
  }

  Widget body(OrdemModel ordem) {
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
                _statusWidget(ordem),
                for (final produto in ordem.produtos)
                  _produtoWidget(ordem, produto),
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
            onTap: () => ordem.materiaPrima != null
                ? push(
                    context,
                    MateriaPrimaCreatePage(
                      materiaPrima: FirestoreClient.materiaPrimas.getById(
                        ordem.materiaPrima!.id,
                      ),
                    ),
                  )
                : null,
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

  Padding _statusWidget(OrdemModel ordem) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Status', style: AppCss.largeBold)),
              if (usuario.isNotOperador)
                if (ordem.produtos.isNotEmpty)
                  InkWell(
                    onTap: () => ordemCtrl.showBottomChangeProdutosStatus(
                      ordem.produtos,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            Text(
                              'Mover todos para',
                              style: AppCss.mediumRegular.setSize(12),
                            ),
                            const W(2),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          const H(8),
          if (ordem.pedidos.isEmpty)
            Row(
              children: [
                const Icon(Symbols.brightness_empty),
                const W(8),
                Text(
                  'Ordem vazia, não contem pedidos.',
                  style: AppCss.mediumRegular.setColor(Colors.grey[700]!),
                ),
              ],
            ),
          if (ordem.pedidos.isNotEmpty) ...[
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Aguardando Produção',
                        style: AppCss.mediumRegular,
                      ),
                    ),
                    Text(
                      '${ordem.qtdeAguardando().toKg()} (${(ordem.getPrcntgAguardando() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgAguardando(),
                  backgroundColor: PedidoProdutoStatus.aguardandoProducao.color
                      .withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation(
                    PedidoProdutoStatus.aguardandoProducao.color,
                  ),
                ),
              ],
            ),
            const H(16),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Produzindo', style: AppCss.mediumRegular),
                    ),
                    Text(
                      '${ordem.qtdeProduzindo().toKg()} (${(ordem.getPrcntgProduzindo() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgProduzindo(),
                  backgroundColor: PedidoProdutoStatus.produzindo.color
                      .withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation(
                    PedidoProdutoStatus.produzindo.color,
                  ),
                ),
              ],
            ),
            const H(16),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Pronto', style: AppCss.mediumRegular),
                    ),
                    Text(
                      '${ordem.qtdePronto().toKg()} (${(ordem.getPrcntgPronto() * 100).percent}%)',
                    ),
                  ],
                ),
                const H(8),
                LinearProgressIndicator(
                  value: ordem.getPrcntgPronto(),
                  backgroundColor: PedidoProdutoStatus.pronto.color.withValues(
                    alpha: 0.3,
                  ),
                  valueColor: AlwaysStoppedAnimation(
                    PedidoProdutoStatus.pronto.color,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _produtoWidget(OrdemModel ordem, PedidoProdutoModel produto) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListTile(
        title: Row(
          children: [
            if (produto.pedido.tags.isNotEmpty)
              _tagWidget(produto.pedido.tags.first),
            Text(produto.pedido.localizador, style: AppCss.minimumBold),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  produto.qtde.toKg(),
                  style: AppCss.minimumRegular.setSize(12),
                ),
              ],
            ),
            Text(
              '${produto.cliente.nome} - ${produto.obra.descricao}',
              style: AppCss.minimumRegular.setSize(12),
            ),
            if (produto.pedido.deliveryAt != null)
              Text(
                'Previsão de Entrega: ${produto.pedido.deliveryAt.text()}',
                style: AppCss.minimumRegular
                    .copyWith(fontSize: 12)
                    .setColor(AppColors.neutralDark),
              ),
            if (produto.materiaPrima != null)
              InkWell(
                onTap: () => push(
                  context,
                  MateriaPrimaCreatePage(
                    materiaPrima: FirestoreClient.materiaPrimas.getById(
                      produto.materiaPrima!.id,
                    ),
                  ),
                ),
                child: Text(
                  'Materia Prima: ${produto.materiaPrima!.label}',
                  style: AppCss.minimumRegular
                      .copyWith(fontSize: 12)
                      .setColor(AppColors.neutralDark),
                ),
              ),
          ],
        ),
        trailing: usuario.isOperador
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    [
                          PedidoProdutoStatus.aguardandoProducao,
                          PedidoProdutoStatus.produzindo,
                          PedidoProdutoStatus.pronto,
                        ]
                        .map(
                          (status) => InkWell(
                            onTap: status == produto.status.status
                                ? null
                                : () => ordemCtrl.onSelectProdutoStatus(
                                    ordem,
                                    produto,
                                    status,
                                  ),
                            child: Tooltip(
                              enableFeedback: status != produto.status.status,
                              message: status == produto.status.status
                                  ? 'Este pedido atualmente está ${status.label}'
                                  : 'Clique para alterar para ${status.label}',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: status.color.withValues(
                                    alpha: status == produto.status.status
                                        ? 1
                                        : 0.1,
                                  ),
                                ),
                                child: Text(
                                  status.label,
                                  style: AppCss.minimumRegular
                                      .setSize(16)
                                      .copyWith(
                                        color:
                                            (status ==
                                                        PedidoProdutoStatus
                                                            .pronto
                                                    ? Colors.white
                                                    : Colors.black)
                                                .withValues(
                                                  alpha:
                                                      status ==
                                                          produto.status.status
                                                      ? 1
                                                      : 0.4,
                                                ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              )
            : InkWell(
                onTap: () =>
                    ordemCtrl.showBottomChangeProdutoStatus(ordem, produto),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: produto.statusView.status.color.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Text(
                          produto.statusView.status.label,
                          style: AppCss.mediumRegular.setSize(12),
                        ),
                        const W(2),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColors.black.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Container _tagWidget(TagModel tag) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
      decoration: BoxDecoration(
        color: tag.color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        tag.nome,
        style: TextStyle(
          color: tag.color.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
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
