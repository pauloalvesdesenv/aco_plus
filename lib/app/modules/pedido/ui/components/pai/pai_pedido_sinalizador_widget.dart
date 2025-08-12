import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';

class PaiPedidoSinalizadorWidget extends StatelessWidget {
  const PaiPedidoSinalizadorWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Pedido Pai',
              style: AppCss.minimumRegular.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${pedido.getPedidosFilhos().length} Filho(s)',
            style: AppCss.minimumRegular.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
