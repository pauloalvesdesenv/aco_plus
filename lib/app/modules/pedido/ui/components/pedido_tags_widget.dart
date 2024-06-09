import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_tag_bottom.dart';
import 'package:flutter/material.dart';

class PedidoTagsWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoTagsWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      width: double.maxFinite,
      height: 43,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: () async {
              final tag = await showPedidoTagBottom(pedido);
              if (tag != null) {
                pedido.tags.add(tag);
                pedidoCtrl.updatePedidoFirestore();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4)),
              child: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
          for (final tag in pedido.tags)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: tag.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Text(tag.nome,
                      style: AppCss.mediumRegular.setSize(13).copyWith(
                          fontWeight: FontWeight.w500, color: tag.color)),
                  const W(8),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7)),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 10,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
