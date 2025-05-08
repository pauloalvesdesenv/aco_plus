import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';

enum RelatorioPedidoTipo { totaisPedidos, totais, pedidos }

extension RelatorioTipoStatusExtension on RelatorioPedidoTipo {
  String get label {
    switch (this) {
      case RelatorioPedidoTipo.pedidos:
        return 'Pedidos';
      case RelatorioPedidoTipo.totais:
        return 'Totais';
      case RelatorioPedidoTipo.totaisPedidos:
        return 'Totais e Pedidos';
    }
  }
}

class RelatorioPedidoViewModel {
  ClienteModel? cliente;
  List<PedidoProdutoStatus> status =
      [
        PedidoProdutoStatus.separado,
        PedidoProdutoStatus.aguardandoProducao,
        PedidoProdutoStatus.produzindo,
      ].toList();
  List<ProdutoModel> produtos = FirestoreClient.produtos.data.toList();
  RelatorioPedidoModel? relatorio;
  late SortType sortType;
  SortOrder sortOrder = SortOrder.asc;
  RelatorioPedidoTipo tipo = RelatorioPedidoTipo.totaisPedidos;

  List<SortType> sortTypes = [
    SortType.localizator,
    SortType.deliveryAt,
    SortType.client,
  ];

  RelatorioPedidoViewModel() {
    sortType = sortTypes.first;
  }
}

class RelatorioPedidoModel {
  final ClienteModel? cliente;
  final List<PedidoProdutoStatus> status;
  final List<ProdutoModel> produtos;
  final List<PedidoModel> pedidos;
  final DateTime createdAt = DateTime.now();
  final RelatorioPedidoTipo tipo;

  RelatorioPedidoModel(
    this.cliente,
    this.status,
    this.pedidos,
    this.tipo,
    this.produtos,
  );
}
