import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommentWidget extends StatelessWidget {
  final int index;
  final CommentModel comment;
  final void Function(CommentModel comment) onRemove;

  const CommentWidget({
    required this.index,
    required this.comment,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(name: comment.user.nome),
        const W(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.user.nome, style: AppCss.mediumBold),
                  const W(12),
                  Text(
                    comment.updatedAt.timeAgo(),
                    style: AppCss.mediumRegular.copyWith(
                      color: Colors.grey[800]!,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () =>
                        pedidoCtrl.onFixComment(pedidoCtrl.pedido, index),
                    child: Icon(
                      comment.isFixed
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: comment.isFixed
                          ? Colors.orange
                          : Colors.grey[800],
                      size: 22,
                    ),
                  ),
                ],
              ),
              const H(8),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  comment.delta,
                  style: AppCss.mediumRegular.copyWith(fontSize: 16),
                ),
              ),
              const H(8),
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () async => Clipboard.setData(
                      ClipboardData(text: comment.delta.toString()),
                    ),
                    child: Icon(Icons.copy, color: Colors.grey[800], size: 22),
                  ),
                  const W(8),
                  InkWell(
                    onTap: () async {
                      if (await showConfirmDialog(
                        'Deseja excluir o comentário?',
                        'Não será possível desfazer essa ação.',
                      )) {
                        onRemove.call(comment);
                        pedidoCtrl.onAddHistory(
                          pedido: pedidoCtrl.pedido,
                          data: comment,
                          type: PedidoHistoryType.comment,
                          action: PedidoHistoryAction.delete,
                        );
                      }
                    },
                    child: Icon(Icons.delete, color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
