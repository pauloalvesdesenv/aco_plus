import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TagCollection {
  static final TagCollection _instance = TagCollection._();

  TagCollection._();

  factory TagCollection() => _instance;
  String name = 'tags';

  AppStream<List<TagModel>> dataStream = AppStream<List<TagModel>>();
  List<TagModel> get data => dataStream.value;

  TagModel get cd =>
      data.firstWhere((e) => e.nome.replaceAll(' ', '').toLowerCase() == 'cd');
  TagModel get cda =>
      data.firstWhere((e) => e.nome.replaceAll(' ', '').toLowerCase() == 'cda');

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
    final countries = data.docs.map((e) => TagModel.fromMap(e.data())).toList();
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
          final countries = e.docs
              .map((e) => TagModel.fromMap(e.data()))
              .toList();
          countries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          dataStream.add(countries);
        });
  }

  TagModel getById(String id) => data.singleWhere((e) => e.id == id);

  Future<TagModel?> add(TagModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<TagModel?> update(TagModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(TagModel model) async {
    await collection.doc(model.id).delete();
  }
}
