import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistCollection {
  static final ChecklistCollection _instance = ChecklistCollection._();

  ChecklistCollection._();

  factory ChecklistCollection() => _instance;
  String name = 'checklist';

  AppStream<List<ChecklistModel>> dataStream =
      AppStream<List<ChecklistModel>>();
  List<ChecklistModel> get data => dataStream.value;

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
        data.docs.map((e) => ChecklistModel.fromMap(e.data())).toList();
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
          e.docs.map((e) => ChecklistModel.fromMap(e.data())).toList();
      countries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      dataStream.add(countries);
    });
  }

  ChecklistModel getById(String id) => data.singleWhere((e) => e.id == id);

  Future<ChecklistModel?> add(ChecklistModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<ChecklistModel?> update(ChecklistModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(ChecklistModel model) async {
    await collection.doc(model.id).delete();
  }
}
