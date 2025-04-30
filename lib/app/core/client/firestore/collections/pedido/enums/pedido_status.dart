import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:flutter/material.dart';

enum PedidoStatus {
  produzindoCD,
  aguardandoProducaoCD,
  aguardandoProducaoCDA,
  produzindoCDA,
  pronto,
}

extension PedidoStatusExtension on PedidoStatus {
  String get label {
    switch (this) {
      case PedidoStatus.produzindoCD:
        return 'Produzindo CD';
      case PedidoStatus.aguardandoProducaoCD:
        return 'Aguardando Produção CD';
      case PedidoStatus.aguardandoProducaoCDA:
        return 'Aguardando Produção CDA';
      case PedidoStatus.produzindoCDA:
        return 'Produzindo CDA';
      case PedidoStatus.pronto:
        return 'Pronto';
    }
  }

  Color get color {
    switch (this) {
      case PedidoStatus.produzindoCD:
        return Colors.yellow;
      case PedidoStatus.aguardandoProducaoCD:
        return Colors.grey[300]!;
      case PedidoStatus.aguardandoProducaoCDA:
        return Colors.grey;
      case PedidoStatus.produzindoCDA:
        return Colors.orange;
      case PedidoStatus.pronto:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case PedidoStatus.produzindoCD:
        return Icons.build;
      case PedidoStatus.aguardandoProducaoCD:
        return Icons.watch_later;
      case PedidoStatus.aguardandoProducaoCDA:
        return Icons.watch_later;
      case PedidoStatus.produzindoCDA:
        return Icons.build;
      case PedidoStatus.pronto:
        return Icons.check;
    }
  }
}

List<PedidoStatus> getPedidosStatusByPedido(PedidoModel pedido) =>
    pedido.tipo == PedidoTipo.cda
        ? [
            PedidoStatus.aguardandoProducaoCDA,
            PedidoStatus.produzindoCDA,
            PedidoStatus.pronto,
          ]
        : [PedidoStatus.produzindoCD, PedidoStatus.pronto];
