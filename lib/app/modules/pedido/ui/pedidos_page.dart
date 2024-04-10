import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_create_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(
            Icons.menu,
            color: AppColors.white,
          ),
        ),
        title: Text('Pedidos', style: AppCss.largeBold.setColor(AppColors.white)),
        actions: [
          IconButton(
              onPressed: () => push(context, const PedidoCreatePage()),
              icon: Icon(
                Icons.add,
                color: AppColors.white,
              ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<PedidoModel>>(
        stream: FirestoreClient.pedidos.dataStream.listen,
        builder: (_, __) => StreamOut<PedidoUtils>(
          stream: pedidoCtrl.utilsStream.listen,
          builder: (_, utils) {
            final pedidos = pedidoCtrl.getPedidoesFiltered(utils.search.text, __).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => pedidoCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: pedidos.isEmpty
                      ? const EmptyData()
                      : ListView.separated(
                          itemCount: pedidos.length,
                          separatorBuilder: (_, i) => const Divisor(),
                          itemBuilder: (_, i) => _itemPedidoWidget(pedidos[i]),
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
    return InkWell(
      onTap: () => push(PedidoPage(pedido)),
      child: Container(
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
                        .map((e) => '${'${e.produto.descricao} - ${e.qtde}'}Kg')
                        .join(', '),
                    style: AppCss.minimumRegular.setSize(11).setColor(AppColors.black),
                  ),
                  Text(
                    'Criada dia ${pedido.createdAt.text()}',
                    style: AppCss.minimumRegular.setSize(11).setColor(AppColors.neutralMedium),
                  ),
                ],
              ),
            ),
            const W(8),
            _progressChartWidget(
                PedidoProdutoStatus.aguardandoProducao, pedido.getPrcntgAguardandoProducao()),
            const W(16),
            _progressChartWidget(PedidoProdutoStatus.produzindo, pedido.getPrcntgProduzindo()),
            const W(16),
            _progressChartWidget(PedidoProdutoStatus.pronto, pedido.getPrcntgPronto()),
            const W(16),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.neutralMedium,
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