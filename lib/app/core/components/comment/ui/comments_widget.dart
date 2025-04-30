import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/http/fcm/fcm_provider.dart';
import 'package:aco_plus/app/core/client/http/fcm/models/fcm_data_model.dart';
import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/components/comment/ui/comment_add_widget.dart';
import 'package:aco_plus/app/core/components/comment/ui/comment_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatelessWidget {
  final String titleNotification;
  final List<CommentModel> items;
  final void Function() onChanged;

  const CommentsWidget({
    required this.titleNotification,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comentários', style: AppCss.largeBold),
        const H(16),
        Column(
          children: [
            CommentAddWidget(
              onSave: (text, mentions) {
                for (var user in mentions) {
                  FCMProvider.postSend(
                    user.id,
                    FCMDataModel(
                            title: titleNotification,
                            description: text,
                            token: user.deviceTokens.lastOrNull,
                            data: {'type': 'event', 'id': pedidoCtrl.pedido.id})
                        .toMap(),
                  );
                }
                items.add(
                  CommentModel(
                    user: usuario,
                    delta: text,
                    isEdited: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    respostas: [],
                    mentioneds: mentions,
                  ),
                );
                pedidoCtrl.onAddHistory(
                  pedido: pedidoCtrl.pedido,
                  data: items.last,
                  type: PedidoHistoryType.comment,
                  action: PedidoHistoryAction.create,
                );
                onChanged();
              },
            ),
            ...items.reversed.map(
              (e) => CommentWidget(
                comment: e,
                onRemove: (comment) {
                  items.remove(comment);
                  onChanged();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
