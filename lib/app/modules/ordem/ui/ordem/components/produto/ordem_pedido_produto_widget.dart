import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materia_prima_bottom.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_create_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/produto/ordem_pedido_produto_pause_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/produto/status/ordem_pedido_status_normal_widget.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/produto/status/ordem_pedido_status_operator_widget.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdemPedidoProdutoWidget extends StatelessWidget {
  final PedidoProdutoModel produto;
  final OrdemModel ordem;
  final MateriaPrimaModel? materiaPrima;

  const OrdemPedidoProdutoWidget({
    super.key,
    required this.produto,
    required this.ordem,
    required this.materiaPrima,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: produto.isPaused ? Colors.grey.withValues(alpha: 0.1) : null,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (produto.isPaused) _pauseTagWidget(),
                    if (produto.pedido.tags.isNotEmpty)
                      _tagWidget(produto.pedido.tags.first),
                    Text(produto.pedido.localizador, style: AppCss.minimumBold),
                  ],
                ),

                Text(
                  produto.qtde.toKg(),
                  style: AppCss.minimumRegular.setSize(12),
                ),
                Text(
                  '${produto.cliente.nome} - ${produto.obra.descricao}',
                  style: AppCss.minimumRegular.setSize(12),
                ),
                if (produto.pedido.deliveryAt != null)
                  Text(
                    'Previsão de Entrega: ${produto.pedido.deliveryAt?.text()}',
                    style: AppCss.minimumRegular
                        .copyWith(fontSize: 12)
                        .setColor(AppColors.neutralDark),
                  ),
                if (materiaPrima != null)
                  InkWell(
                    onTap: () async {
                      final result = await showMateriaPrimaBottom(
                        materiaPrima!,
                      );
                      if (result != null) {
                        push(
                          context,
                          MateriaPrimaCreatePage(materiaPrima: materiaPrima),
                        );
                      }
                    },
                    child: Text(
                      'Materia Prima: ${materiaPrima?.label}',
                      style: AppCss.minimumRegular
                          .copyWith(fontSize: 12)
                          .setColor(AppColors.neutralDark),
                    ),
                  ),
              ],
            ),
          ),
          Gap(8),
          _statusWidget(),
          if (produto.statusView.status == PedidoProdutoStatus.produzindo)
            OrdemPedidoProdutoPauseWidget(ordem: ordem, produto: produto),
        ],
      ),
    );
  }

  Widget _statusWidget() {
    return usuario.isOperador
        ? OrdemPedidoStatusOperatorWidget(produto: produto, ordem: ordem)
        : OrdemPedidoStatusNormalWidget(produto: produto, ordem: ordem);
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

  Container _pauseTagWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        'PAUSADO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
