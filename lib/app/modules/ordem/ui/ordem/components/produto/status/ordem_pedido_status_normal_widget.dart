import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdemPedidoStatusNormalWidget extends StatelessWidget {
  final PedidoProdutoModel produto;
  final OrdemModel ordem;
  const OrdemPedidoStatusNormalWidget({
    super.key,
    required this.produto,
    required this.ordem,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: produto.isPaused,
      child: InkWell(
        onTap: () => ordemCtrl.showBottomChangeProdutoStatus(ordem, produto),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: produto.statusView.status.color.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Text(
                  produto.statusView.status.label,
                  style: AppCss.mediumRegular.setSize(12),
                ),
                const Gap(2),
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
    );
  }
}
