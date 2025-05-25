import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/comment/ui/comments_widget.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class PedidoCommentsWidget extends StatelessWidget {
  final PedidoModel pedido;
  const PedidoCommentsWidget(this.pedido, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamOut(
            stream: pedidoCtrl.utilsStream.listen,
            builder: (_, utils) => CommentsWidget(
              titleNotification:
                  '${usuario.nome} mencionou você no pedido ${pedido.localizador}',
              items: pedido.comments,
              onChanged: () => pedidoCtrl.updatePedidoFirestore(),
            ),
          ),
        ],
      ),
    );
  }
}
