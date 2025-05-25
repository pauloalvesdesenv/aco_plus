import 'package:aco_plus/app/core/client/firestore/collections/notificacao/notificacao_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class NotificacaoCollection {
  static final NotificacaoCollection _instance = NotificacaoCollection._();

  NotificacaoCollection._();

  factory NotificacaoCollection() => _instance;
  String name = 'notificacoes';

  AppStream<List<NotificacaoModel>> dataStream =
      AppStream<List<NotificacaoModel>>();
  List<NotificacaoModel> get data =>
      dataStream.value.where((e) => e.userId == usuario.id).toList();

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
    final notiticacoes = data.docs
        .map((e) => NotificacaoModel.fromMap(e.data()))
        .toList();
    notiticacoes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    dataStream.add(notiticacoes);
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
          final notificacoes = e.docs
              .map((e) => NotificacaoModel.fromMap(e.data()))
              .toList();
          notificacoes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          dataStream.add(notificacoes);
        });
  }

  NotificacaoModel getById(String id) =>
      data.firstWhereOrNull((e) => e.id == id) ?? NotificacaoModel.empty();

  Future<NotificacaoModel?> add(NotificacaoModel model) async {
    await collection.doc(model.id).set(model.toMap());
    return model;
  }

  Future<NotificacaoModel?> update(NotificacaoModel model) async {
    await collection.doc(model.id).update(model.toMap());
    return model;
  }

  Future<void> delete(NotificacaoModel model) async {
    await collection.doc(model.id).delete();
  }
}
