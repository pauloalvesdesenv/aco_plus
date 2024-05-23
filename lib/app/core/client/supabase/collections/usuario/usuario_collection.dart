import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';

class UsuarioCollection {
  static final UsuarioCollection _instance = UsuarioCollection._();

  UsuarioCollection._();

  factory UsuarioCollection() => _instance;
  String name = 'usuarios';

  AppStream<List<UsuarioModel>> dataStream = AppStream<List<UsuarioModel>>();
  List<UsuarioModel> get data => dataStream.value;

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
    final countries = data.docs.map((e) => UsuarioModel.fromMap(e.data())).toList();
    countries.sort((a, b) => a.nome.compareTo(b.nome));
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
      final countries = e.docs.map((e) => UsuarioModel.fromMap(e.data())).toList();
      countries.sort((a, b) => a.nome.compareTo(b.nome));
      dataStream.add(countries);
    });
  }

  UsuarioModel getById(String id) => data.singleWhere((e) => e.id == id);

  Future<UsuarioModel?> add(UsuarioModel model) async {
    try {
      await collection.doc(model.id).set(model.toMap());
      return model;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<UsuarioModel?> update(UsuarioModel model) async {
    try {
      await collection.doc(model.id).update(model.toMap());
      return model;
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
      return null;
    }
  }

  Future<void> delete(UsuarioModel model) async {
    await collection.doc(model.id).delete();
  }
}
