import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class StepCollection {
  static final StepCollection _instance = StepCollection._();

  StepCollection._();

  factory StepCollection() => _instance;
  String name = 'steps';

  AppStream<List<StepModel>> dataStream = AppStream<List<StepModel>>();
  List<StepModel> get data => dataStream.value;

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
        data.docs.map((e) => StepModel.fromMap(e.data())).toList();
    countries.sort((a, b) => a.index.compareTo(b.index));
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
      final countries = e.docs.map((e) => StepModel.fromMap(e.data())).toList();
      countries.sort((a, b) => a.index.compareTo(b.index));
      dataStream.add(countries);
    });
  }

  StepModel getById(String id) {
    if (!dataStream.controller.hasValue) return StepModel.notFound;
    final step = data.firstWhereOrNull((e) => e.id == id);
    return step ?? StepModel.notFound;
  }

  Future<StepModel?> add(StepModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<StepModel?> update(StepModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(StepModel model) async {
    await collection.doc(model.id).delete();
  }

  Future<void> setDefault(String id) async {
    for (final step in data) {
      step.isDefault = step.id == id;
      dataStream.update();
      await update(step);
    }
  }
}
