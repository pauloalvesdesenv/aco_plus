import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
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
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_create_page.dart';
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
    ordemCtrl.onInitPage(widget.ordemId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamOut(
      stream: ordemCtrl.ordemStream.listen,
      builder: (_, ordem) => AppScaffold(
          resizeAvoid: true,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () async =>
                      push(context, OrdemCreatePage(ordem: ordem)),
                  icon: Icon(Icons.edit, color: AppColors.white)),
              IconButton(
                  onPressed: () async => ordemCtrl.onDelete(context, ordem),
                  icon: Icon(Icons.delete, color: AppColors.white))
            ],
            title: Text('Ordem ${ordem.id}',
                style: AppCss.largeBold.setColor(AppColors.white)),
            backgroundColor: AppColors.primaryMain,
          ),
          body: StreamOut(
              stream: ordemCtrl.ordemStream.listen,
              builder: (_, form) => body(form))),
    );
  }

  Widget body(OrdemModel ordem) {
    return RefreshIndicator(
      onRefresh: () async {
        await FirestoreClient.ordens.fetch();
        ordemCtrl.getOrdemById(widget.ordemId);
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: RowItensLabel([
              ItemLabel('Produto',
                  '${ordem.produto.nome} - ${ordem.produto.descricao}'),
              ItemLabel('Iniciada', ordem.createdAt.text()),
              if (ordem.endAt != null)
                ItemLabel('Finalizada', ordem.endAt.text()),
            ]),
          ),
          const Divisor(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status', style: AppCss.largeBold),
                const H(8),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text('Aguardando Produção',
                                style: AppCss.mediumRegular)),
                        Text(
                          '${ordem.qtdeAguardando().toKg()} (${(ordem.getPrcntgAguardando() * 100).percent}%)',
                        )
                      ],
                    ),
                    const H(8),
                    LinearProgressIndicator(
                      value: ordem.getPrcntgAguardando(),
                      backgroundColor: PedidoProdutoStatus
                          .aguardandoProducao.color
                          .withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                          PedidoProdutoStatus.aguardandoProducao.color),
                    ),
                  ],
                ),
                const H(16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text('Produzindo',
                                style: AppCss.mediumRegular)),
                        Text(
                          '${ordem.qtdeProduzindo().formatted}Kg (${(ordem.getPrcntgProduzindo() * 100).percent}%)',
                        )
                      ],
                    ),
                    const H(8),
                    LinearProgressIndicator(
                      value: ordem.getPrcntgProduzindo(),
                      backgroundColor:
                          PedidoProdutoStatus.produzindo.color.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                          PedidoProdutoStatus.produzindo.color),
                    ),
                  ],
                ),
                const H(16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text('Pronto', style: AppCss.mediumRegular)),
                        Text(
                          '${ordem.qtdePronto().toKg()} (${(ordem.getPrcntgPronto() * 100).percent}%)',
                        )
                      ],
                    ),
                    const H(8),
                    LinearProgressIndicator(
                      value: ordem.getPrcntgPronto(),
                      backgroundColor:
                          PedidoProdutoStatus.pronto.color.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(
                          PedidoProdutoStatus.pronto.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
          for (final produto in ordem.produtos)
            ListTile(
              title: Text(
                '${produto.qtde}Kg',
                style: AppCss.minimumBold,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const H(2),
                  Text(
                      '${produto.pedido.localizador} - ${produto.cliente.nome}',
                      style: AppCss.minimumRegular.setSize(12)),
                  Text(produto.obra.descricao ?? 'Não Disponível',
                      style: AppCss.minimumRegular.setSize(12)),
                ],
              ),
              trailing: InkWell(
                onTap: () => ordemCtrl.showBottomChangeProdutoStatus(produto),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: produto.statusView.status.color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4)),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Text(produto.statusView.status.label,
                            style: AppCss.mediumRegular.setSize(12)),
                        const W(2),
                        Icon(Icons.keyboard_arrow_down,
                            size: 16, color: AppColors.black.withOpacity(0.6))
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
