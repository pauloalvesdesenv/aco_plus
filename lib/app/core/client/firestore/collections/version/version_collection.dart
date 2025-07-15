import 'package:aco_plus/app/core/client/firestore/collections/version/models/version_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/modules/version/ui/version_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VersionCollection {
  static int version = 423;
  static final VersionCollection _instance = VersionCollection._();

  VersionCollection._();

  factory VersionCollection() => _instance;
  String name = 'version';

  AppStream<VersionModel> dataStream = AppStream<VersionModel>();
  VersionModel get data => dataStream.value;

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
    final version = VersionModel.fromMap(data.docs.first.data());
    dataStream.add(version);
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
        .listen((e) async {
          final version = VersionModel.fromMap(e.docs.first.data());
          dataStream.add(version);
          _checkVersion(version);
        });
  }

  Future<void> _checkVersion(VersionModel version) async {
    if (version.number > VersionCollection.version) {
      await showVersionDialog(version);
    }
  }
}
