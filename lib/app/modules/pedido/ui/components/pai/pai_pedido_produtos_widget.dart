import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pai/pai_pedido_produto_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_page.dart';
import 'package:flutter/material.dart';

class PaiPedidoProdutosWidget extends StatefulWidget {
  final PedidoModel pedido;
  const PaiPedidoProdutosWidget(this.pedido, {super.key});

  @override
  State<PaiPedidoProdutosWidget> createState() =>
      _PaiPedidoProdutosWidgetState();
}

class _PaiPedidoProdutosWidgetState extends State<PaiPedidoProdutosWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.pedido.produtos
          .map((produto) => PaiPedidoProdutoWidget(widget.pedido, produto))
          .toList(),
    );
  }

}
