import 'dart:developer';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoCollection {
  static final PedidoCollection _instance = PedidoCollection._();

  PedidoCollection._();

  factory PedidoCollection() => _instance;
  String name = 'pedidos';

  AppStream<List<PedidoModel>> dataStream = AppStream<List<PedidoModel>>();
  List<PedidoModel> get data => dataStream.value;

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
    final countries =
        data.docs.map((e) => PedidoModel.fromMap(e.data())).toList();
    countries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    dataStream.add(countries);
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
      final countries =
          e.docs.map((e) => PedidoModel.fromMap(e.data())).toList();
      countries.sort((a, b) => a.localizador.compareTo(b.localizador));
      dataStream.add(countries);
    });
  }

  PedidoModel getById(String id) => data.singleWhere((e) => e.id == id);
  PedidoProdutoModel getProdutoByPedidoId(String pedidoId, String produtoId) =>
      getById(pedidoId).produtos.firstWhere((e) => e.id == produtoId);

  Future<PedidoModel?> add(PedidoModel model) async {
    try {
      await collection.doc(model.id).set(model.toMap());
      return model;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<PedidoModel?> update(PedidoModel model) async {
    try {
      await collection.doc(model.id).update(model.toMap());
      return model;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<void> delete(PedidoModel model) async {
    await collection.doc(model.id).delete();
  }

  Future<void> fetchAllItens() async {
    for (final pedido in data) {
      await FirestoreClient.pedidos.update(pedido);
    }
  }
}
