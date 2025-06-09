import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class PedidoCollection {
  static final PedidoCollection _instance = PedidoCollection._();

  PedidoCollection._();

  factory PedidoCollection() => _instance;
  String name = 'pedidos';

  AppStream<List<PedidoModel>> dataStream = AppStream<List<PedidoModel>>();
  List<PedidoModel> get data => dataStream.value;

  AppStream<List<PedidoModel>> pedidosUnarchivedsStream =
      AppStream<List<PedidoModel>>();
  List<PedidoModel> get pepidosUnarchiveds => pedidosUnarchivedsStream.value;

  AppStream<List<PedidoModel>> pedidosArchivedsStream =
      AppStream<List<PedidoModel>>();
  List<PedidoModel> get pedidosArchiveds => pedidosArchivedsStream.value;

  AppStream<List<PedidoModel>> pedidosPrioridadeStream =
      AppStream<List<PedidoModel>>();
  List<PedidoModel> get pedidosPrioridade => pedidosPrioridadeStream.value;

  CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(name);

  Future<void> fetch({bool lock = true, GetOptions? options}) async {
    _isStarted = false;
    await start(lock: false, options: options);
    _isStarted = true;
  }

  bool _isStarted = false;
  Future<void> start({bool lock = true, GetOptions? options}) async {
    if (_isStarted && lock) return;
    _isStarted = true;
    final data = await FirebaseFirestore.instance.collection(name).get();
    final pedidos = data.docs
        .map((e) => PedidoModel.fromMap(e.data()))
        .toList();
    dataStream.add(pedidos);
    pedidosUnarchivedsStream.add(pedidos.where((e) => !e.isArchived).toList());
    pedidosArchivedsStream.add(pedidos.where((e) => e.isArchived).toList());
    pedidosPrioridadeStream.add(
      pedidos.where((e) => e.prioridade != null).toList(),
    );
  }

  bool _isListen = false;
  Future<void> listen({
    Object? field,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    if (_isListen) return;
    _isListen = true;
    (field != null
            ? collection.where(
                field,
                isEqualTo: isEqualTo,
                isNotEqualTo: isNotEqualTo,
                isLessThan: isLessThan,
                isLessThanOrEqualTo: isLessThanOrEqualTo,
                isGreaterThan: isGreaterThan,
                isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
                arrayContains: arrayContains,
                arrayContainsAny: arrayContainsAny,
                whereIn: whereIn,
                whereNotIn: whereNotIn,
                isNull: isNull,
              )
            : collection)
        .snapshots()
        .listen((e) {
          final data = e.docs
              .map((e) => PedidoModel.fromMap(e.data()))
              .toList();
          dataStream.add(data);
          pedidosUnarchivedsStream.add(
            data.where((e) => !e.isArchived).toList(),
          );
          pedidosArchivedsStream.add(data.where((e) => e.isArchived).toList());
          pedidosPrioridadeStream.add(
            data.where((e) => e.prioridade != null).toList(),
          );
        });
  }

  PedidoModel getById(String id) =>
      data.firstWhereOrNull((e) => e.id == id) ?? PedidoModel.empty();

  PedidoProdutoModel getProdutoByPedidoId(String pedidoId, String produtoId) =>
      getById(pedidoId).produtos.firstWhereOrNull((e) => e.id == produtoId) ??
      PedidoProdutoModel.empty(getById(pedidoId));

  Future<PedidoModel?> add(PedidoModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<PedidoModel?> update(PedidoModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(PedidoModel model) async {
    await collection.doc(model.id).delete();
  }

  Future<void> updateAll(List<PedidoModel> pedidos) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var pedido in pedidos) {
      var map = pedido.toMap();
      batch.update(collection.doc(pedido.id), map);
    }
    await batch.commit();
  }

   Future<void> updateProdutoMateriaPrima(
    PedidoProdutoModel produto,
    MateriaPrimaModel? materiaPrima,
  ) async {
    final pedido = getById(produto.pedidoId);

    final pedidoProduto = pedido.produtos.firstWhere(
      (element) => element.id == produto.id,
    );

    pedidoProduto.materiaPrima = materiaPrima;

    return await collection.doc(pedido.id).update(pedido.toMap());
  }

  Future<void> updateProdutoStatus(
    PedidoProdutoModel produto,
    PedidoProdutoStatus status, {
    bool clear = false,
  }) async {
    final pedido = getById(produto.pedidoId);

    final pedidoProduto = pedido.produtos.firstWhere(
      (element) => element.id == produto.id,
    );

    if (clear) {
      pedidoProduto.statusess.clear();
    }

    if (pedidoProduto.statusess.isEmpty ||
        pedidoProduto.statusess.last.status != status) {
      pedidoProduto.statusess.add(PedidoProdutoStatusModel.create(status));
    }

    return await collection.doc(pedido.id).update(pedido.toMap());
  }

  Future<PedidoModel?> updatePedidoStatus(PedidoProdutoModel produto) async {
    final pedido = getById(produto.pedidoId);
    final status = PedidoStatusModel.create(getPedidoStatusByProduto(pedido));
    if (status.status == pedido.status) return null;
    pedido.statusess.add(status);
    await collection.doc(pedido.id).update(pedido.toMap());
    return pedido;
  }

  PedidoStatus getPedidoStatusByProduto(PedidoModel pedido) {
    bool isAllDone = pedido.produtos.every(
      (e) => e.status.status == PedidoProdutoStatus.pronto,
    );
    if (isAllDone) {
      return pedido.tipo == PedidoTipo.cd
          ? PedidoStatus.pronto
          : PedidoStatus.aguardandoProducaoCDA;
    } else {
      bool isAllAguardandoProducao = pedido.produtos.every(
        (e) => e.status.status == PedidoProdutoStatus.aguardandoProducao,
      );

      return isAllAguardandoProducao
          ? PedidoStatus.aguardandoProducaoCD
          : PedidoStatus.produzindoCD;
    }
  }
}
