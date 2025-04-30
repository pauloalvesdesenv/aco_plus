import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class MateriaPrimaCollection {
  static final MateriaPrimaCollection _instance = MateriaPrimaCollection._();

  MateriaPrimaCollection._();

  factory MateriaPrimaCollection() => _instance;
  String name = 'materias_primas';

  AppStream<List<MateriaPrimaModel>> dataStream =
      AppStream<List<MateriaPrimaModel>>();
  List<MateriaPrimaModel> get data => dataStream.value;

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
        data.docs.map((e) => MateriaPrimaModel.fromMap(e.data())).toList();
    countries.sort((a, b) => a.corridaLote.compareTo(b.corridaLote));
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
              e.docs.map((e) => MateriaPrimaModel.fromMap(e.data())).toList();
          countries.sort((a, b) => a.corridaLote.compareTo(b.corridaLote));
          dataStream.add(countries);
        });
  }

  MateriaPrimaModel getById(String id) =>
      data.firstWhereOrNull((e) => e.id == id) ?? MateriaPrimaModel.empty();

  Future<MateriaPrimaModel?> add(MateriaPrimaModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<MateriaPrimaModel?> update(MateriaPrimaModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(MateriaPrimaModel model) async {
    await collection.doc(model.id).delete();
  }
}
