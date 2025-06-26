import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdemCollection {
  static final OrdemCollection _instance = OrdemCollection._();

  OrdemCollection._();

  factory OrdemCollection() => _instance;
  String name = 'ordens';

  AppStream<List<OrdemModel>> dataStream = AppStream<List<OrdemModel>>();
  List<OrdemModel> get data => dataStream.value;

  AppStream<List<OrdemModel>> ordensNaoArquivadasStream =
      AppStream<List<OrdemModel>>();
  List<OrdemModel> get ordensNaoArquivadas => ordensNaoArquivadasStream.value;

  AppStream<List<OrdemModel>> ordensArquivadasStream =
      AppStream<List<OrdemModel>>();
  List<OrdemModel> get ordensArquivadas => ordensArquivadasStream.value;

  List<OrdemModel> get ordensNaoCongeladas =>
      ordensNaoArquivadas.where((e) => !e.freezed.isFreezed).toList();

  List<OrdemModel> get ordensCongeladas =>
      data.where((e) => e.freezed.isFreezed).toList();

  CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection(name);

  Future<void> startOnlyArquivadas() async {
    final data = await FirebaseFirestore.instance
        .collection(name)
        .where('isArchived', isEqualTo: true)
        .get();
    final ordens = data.docs.map((e) => OrdemModel.fromMap(e.data())).toList();
    ordensArquivadasStream.add(ordens);
  }

  Future<void> fetch({bool lock = true, GetOptions? options}) async {
    _isStarted = false;
    await start(lock: false, options: options);
    _isStarted = true;
  }

  bool _isStarted = false;
  Future<void> start({bool lock = true, GetOptions? options}) async {
    if (_isStarted && lock) return;
    _isStarted = true;
    final data = await FirebaseFirestore.instance
        .collection(name)
        .where('isArchived', isEqualTo: false)
        .get();
    final ordens = data.docs.map((e) => OrdemModel.fromMap(e.data())).toList();
    final ordensNaoArquivadas = ordens.where((e) => !e.isArchived).toList();
    ordensNaoArquivadas.sort((a, b) {
      if (a.freezed.isFreezed && !b.freezed.isFreezed) {
        return 1;
      } else if (!a.freezed.isFreezed && b.freezed.isFreezed) {
        return -1;
      }

      if (a.beltIndex == null || b.beltIndex == null) {
        return 0;
      }
      return a.beltIndex!.compareTo(b.beltIndex!);
    });

    ordensNaoArquivadasStream.add(ordensNaoArquivadas);

    dataStream.add(ordensNaoArquivadas);
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
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .listen((e) {
          final ordens = e.docs
              .map((e) => OrdemModel.fromMap(e.data()))
              .toList();
          final ordensNaoArquivadas = ordens
              .where((e) => !e.isArchived)
              .toList();

          ordensNaoArquivadas.sort((a, b) {
            if (a.freezed.isFreezed && !b.freezed.isFreezed) {
              return 1;
            } else if (!a.freezed.isFreezed && b.freezed.isFreezed) {
              return -1;
            }

            if (a.beltIndex == null || b.beltIndex == null) {
              return 0;
            }
            return a.beltIndex!.compareTo(b.beltIndex!);
          });

          ordensNaoArquivadasStream.add(ordensNaoArquivadas);

          dataStream.add(ordensNaoArquivadas);
        });
  }

  Stream<OrdemModel> listenById(String id) {
    return collection
        .doc(id)
        .snapshots()
        .map((doc) => OrdemModel.fromMap(doc.data()!));
  }

  OrdemModel getById(String id) => ([...data, ...ordensArquivadas])
      .firstWhere((e) => e.id == id);

  Future<OrdemModel?> add(OrdemModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<OrdemModel?> update(OrdemModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(OrdemModel model) async {
    await collection.doc(model.id).delete();
  }

  Future<void> updateAll(List<OrdemModel> ordems) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var ordem in ordems) {
      batch.update(collection.doc(ordem.id), ordem.toMap());
    }
    await batch.commit();
  }
}
