import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_item_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_select_bottom.dart';
import 'package:flutter/material.dart';

class PedidoVinculadosWidget extends StatelessWidget {
  final PedidoModel pedido;
  final List<PedidoModel> vinculados;
  const PedidoVinculadosWidget({
    super.key,
    required this.pedido,
    required this.vinculados,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Pedidos Vinculados', style: AppCss.largeBold),
              ),
              InkWell(
                onTap: () async {
                  final vinculado = await showPedidoSelectBottom(
                    FirestoreClient.pedidos.data
                        .where(
                          (p) =>
                              !vinculados.any((v) => v.id == p.id) &&
                              p.id != pedido.id,
                        )
                        .toList(),
                  );
                  if (vinculado != null) {
                    pedidoCtrl.onAddPedidoVinculado(pedido, vinculado);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMain,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          if (vinculados.isNotEmpty) ...[
            const H(16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFC4CCD3), width: 2),
              ),
              child: Column(
                children: vinculados
                    .map(
                      (vinculado) => Container(
                        color: Color(0xFFFFFFFF),
                        child: Row(
                          children: [
                            Expanded(
                              child: PedidoItemWidget(
                                info: PedidoItemInfo.page,
                                onTap: (pedido) => push(
                                  PedidoPage(
                                    reason: PedidoInitReason.page,
                                    pedido: pedido,
                                  ),
                                ),
                                pedido: vinculado,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: InkWell(
                                onTap: () => pedidoCtrl.onRemovePedidoVinculado(
                                  pedido,
                                  vinculado,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryMain,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
