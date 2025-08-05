import 'package:aco_plus/app/core/components/comment/comment_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';

class KanbanCardCommentsWidget extends StatelessWidget {
  final List<CommentModel> comments;
  const KanbanCardCommentsWidget({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: comments.isEmpty ? 8 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fixados',
            style: AppCss.mediumRegular.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const H(2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments.map((comment) => _commentWidget(comment)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _commentWidget(CommentModel comment) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: comment.isFixed
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        '💬 ${comment.delta}',
        style: AppCss.mediumRegular.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
