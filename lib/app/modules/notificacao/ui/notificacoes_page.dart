import 'package:aco_plus/app/core/client/firestore/collections/notificacao/notificacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/services/push_notification_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_controller.dart';
import 'package:aco_plus/app/modules/notificacao/notificacao_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  @override
  void initState() {
    FirestoreClient.notificacoes.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Notificacões',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<NotificacaoModel>>(
        stream: FirestoreClient.notificacoes.dataStream.listen,
        builder: (_, __) => StreamOut<NotificacaoUtils>(
          stream: notificacaoCtrl.utilsStream.listen,
          builder: (_, utils) {
            List<NotificacaoModel> notificacoes = notificacaoCtrl
                .getNotificacaoesFiltered(utils.search.text, __)
                .toList();

            if (utils.usuarios.isNotEmpty) {
              List<NotificacaoModel> notificaoesPorUsuario = [];
              for (var notificao in notificacoes) {
                for (var usuario in utils.usuarios) {
                  if (notificao.description.toCompare.contains(
                    usuario.nome.toCompare,
                  )) {
                    notificaoesPorUsuario.add(notificao);
                    break;
                  }
                }
              }
              notificacoes = notificaoesPorUsuario;
            }

            notificacoes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AppField(
                        hint: 'Pesquisar',
                        controller: utils.search,
                        suffixIcon: Icons.search,
                        onChanged: (_) => notificacaoCtrl.utilsStream.update(),
                      ),
                      const Gap(16),
                      AppDropDownList<UsuarioModel>(
                        label: 'Filtrar por Usuário',
                        addeds: utils.usuarios,
                        itens: FirestoreClient.usuarios.data,
                        itemLabel: (e) => e.nome,
                        onChanged: () => notificacaoCtrl.utilsStream.update(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: notificacoes.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async =>
                              FirestoreClient.notificacoes.fetch(),
                          child: ListView.separated(
                            itemCount: notificacoes.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemNotificacaoWidget(notificacoes[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _itemNotificacaoWidget(NotificacaoModel notificacao) {
    return InkWell(
      onTap: () {
        if (!notificacao.viewed) {
          notificacao.viewed = true;
          FirestoreClient.notificacoes.update(notificacao);
        }
        handleClickNotification(notificacao.payload);
      },
      child: Container(
        color: notificacao.viewed ? Colors.grey[200] : Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(notificacao.title, style: AppCss.mediumBold),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H(2),
              Text(notificacao.description),
              H(2),
              Text(
                'Enviada em: ${notificacao.createdAt.textHour()}',
                style: AppCss.minimumRegular.copyWith(
                  color: AppColors.neutralMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
