import 'package:aco_plus/app/core/client/firestore/collections/notificacao/notificacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final notificacaoCtrl = NotificacaoController();
NotificacaoModel get notificacao => notificacaoCtrl.notificacao!;

class NotificacaoController {
  static final NotificacaoController _instance = NotificacaoController._();

  NotificacaoController._();

  factory NotificacaoController() => _instance;

  final AppStream<NotificacaoModel?> notificacaoStream =
      AppStream<NotificacaoModel?>.seed(null);
  NotificacaoModel? get notificacao => notificacaoStream.value;

  final AppStream<NotificacaoUtils> utilsStream =
      AppStream<NotificacaoUtils>.seed(NotificacaoUtils());
  NotificacaoUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(NotificacaoUtils());
    FirestoreClient.notificacoes.fetch();
  }

  List<NotificacaoModel> getNotificacaoesFiltered(
      String search, List<NotificacaoModel> notificacoes) {
    if (search.length < 3) return notificacoes;
    List<NotificacaoModel> filtered = [];
    for (final notificacao in notificacoes) {
      if (notificacao.toString().toCompare.contains(search.toCompare)) {
        filtered.add(notificacao);
      }
    }
    return filtered;
  }

  Future<void> onDelete(value, NotificacaoModel notificacao) async {
    if (await _isDeleteUnavailable(notificacao)) return;
    await FirestoreClient.notificacoes.delete(notificacao);
    pop(value);
    NotificationService.showPositive(
        'Notificacao Excluido', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<bool> _isDeleteUnavailable(NotificacaoModel notificacao) async =>
      !await onDeleteProcess(
          deleteTitle: 'Deseja excluir o notificacao?',
          deleteMessage: 'Todos seus dados serão apagados do sistema',
          infoMessage:
              'Não é possível excluir o notificacao, pois ele está vinculado a outras partes do sistema.',
          conditional: true);

  Future<void> setViewed() async {
    for (final notificacao in FirestoreClient.notificacoes.data) {
      if (!notificacao.viewed) {
        notificacao.viewed = true;
        await FirestoreClient.notificacoes.update(notificacao);
      }
    }
  }
}
