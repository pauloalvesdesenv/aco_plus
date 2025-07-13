import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/modules/ordem/ordem_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdemPedidoProdutoPauseWidget extends StatelessWidget {
  final OrdemModel ordem;
  final PedidoProdutoModel produto;

  const OrdemPedidoProdutoPauseWidget({
    super.key,
    required this.ordem,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return produto.isPaused ? _pauseWidget() : _unpauseWidget();
  }

  Widget _pauseWidget() {
    return InkWell(
      onTap: () => ordemCtrl.onUnpauseProduto(ordem, produto),
      child: Container(
        margin: EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [Icon(Icons.play_arrow, size: 15), Gap(2), Text('Continuar')],
        ),
      ),
    );
  }

  Widget _unpauseWidget() {
    return InkWell(
      onTap: () => ordemCtrl.onPauseProduto(ordem, produto),
      child: Container(
        margin: EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [Icon(Icons.play_arrow, size: 15), Gap(2), Text('Pausar')],
        ),
      ),
    );
  }
}
