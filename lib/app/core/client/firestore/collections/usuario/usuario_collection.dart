import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final usuarios =
        data.docs.map((e) => UsuarioModel.fromMap(e.data())).toList();

    dataStream.add(usuarios);
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
      final data = e.docs.map((e) => UsuarioModel.fromMap(e.data())).toList();
      dataStream.add(data);
    });
  }

  UsuarioModel getById(String id) => data.singleWhere((e) => e.id == id);

  Future<UsuarioModel?> add(UsuarioModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<UsuarioModel?> update(UsuarioModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(UsuarioModel model) async {
    await collection.doc(model.id).delete();
  }
}
