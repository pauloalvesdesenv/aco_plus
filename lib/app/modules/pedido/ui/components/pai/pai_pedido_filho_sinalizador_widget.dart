import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PaiPedidoFilhoSinalizadorWidget extends StatelessWidget {
  const PaiPedidoFilhoSinalizadorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          pedidoCtrl.setPedido(FirestoreClient.pedidos.getById(pedido.pai!)),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.red,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Pedido Filho',
                style: AppCss.minimumRegular.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Ir para Pedido Pai',
              style: AppCss.minimumRegular.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
