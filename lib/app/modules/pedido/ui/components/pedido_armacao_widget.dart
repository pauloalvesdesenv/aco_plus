import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class PedidoArmacaoWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoArmacaoWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    final statusess = pedido.getArmacaoStatusses();
    final status = statusess.first;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Armação', style: AppCss.largeBold),
          const H(16),
          ExpansionTile(
            childrenPadding: EdgeInsets.zero,
            tilePadding: EdgeInsets.zero,
            title: _itemWidget(status, status),
            children:
                statusess
                    .getRange(1, statusess.length)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _itemWidget(e, status),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Row _itemWidget(PedidoStatusModel e, PedidoStatusModel status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: e.status.color.withValues(
              alpha: e.id == status.id ? 0.4 : 0.2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            e.status.label,
            style: AppCss.mediumRegular
                .setSize(14)
                .setColor(
                  AppColors.black.withValues(
                    alpha: e.id == status.id ? 1 : 0.4,
                  ),
                ),
          ),
        ),
        Text(
          e.createdAt.textHour(),
          style: AppCss.minimumRegular.setColor(
            AppColors.black.withValues(alpha: e.id == status.id ? 1 : 0.4),
          ),
        ),
      ],
    );
  }
}
