import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_item_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

AutomatizacaoModel get automatizacaoConfig =>
    FirestoreClient.automatizacao.data;

class AutomatizacaoCollection {
  static final AutomatizacaoCollection _instance = AutomatizacaoCollection._();

  AutomatizacaoCollection._();

  factory AutomatizacaoCollection() => _instance;
  String name = 'automatizacao';

  AppStream<AutomatizacaoModel> dataStream = AppStream<AutomatizacaoModel>();
  AutomatizacaoModel get data => dataStream.value;

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
    final automatizacao = AutomatizacaoModel.fromMap(data.docs.first.data());
    dataStream.add(automatizacao);
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
      final automatizacao = AutomatizacaoModel.fromMap(e.docs.first.data());
      dataStream.add(automatizacao);
    });
  }

  Future<void> update(AutomatizacaoModel model) async {
    await collection.doc('instance').update(model.toMap());
  }

  Future<AutomatizacaoModel?> updateF() async {
    final item = AutomatizacaoItemModel(
        type: AutomatizacaoItemType.AGUARDANDO_ARMACAO_PEDIDO,
        step: FirestoreClient.steps.data.first);
    AutomatizacaoModel data = AutomatizacaoModel(
      criacaoPedido: item.copyWith(type: AutomatizacaoItemType.CRIACAO_PEDIDO),
      produtoPedidoSeparado:
          item.copyWith(type: AutomatizacaoItemType.PRODUTO_PEDIDO_SEPARADO),
      produzindoCDPedido:
          item.copyWith(type: AutomatizacaoItemType.PRODUZINDO_CD_PEDIDO),
      prontoCDPedido:
          item.copyWith(type: AutomatizacaoItemType.PRONTO_CD_PEDIDO),
      aguardandoArmacaoPedido:
          item.copyWith(type: AutomatizacaoItemType.AGUARDANDO_ARMACAO_PEDIDO),
      produzindoArmacaoPedido:
          item.copyWith(type: AutomatizacaoItemType.PRODUZINDO_ARMACAO_PEDIDO),
      prontoArmacaoPedido:
          item.copyWith(type: AutomatizacaoItemType.PRONTO_ARMACAO_PEDIDO),
    );
    await collection.doc('instance').update(data.toMap());
    return data;
  }
}
