import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_status_produto_model.dart';
import 'package:aco_plus/app/modules/ordem/ui/components/timeline/ordem_timeline_card_label.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdemTimelineStatusProdutoDetails extends StatelessWidget {
  final OrdemHistoryTypeStatusProdutoModel data;

  const OrdemTimelineStatusProdutoDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrdemTimelineCardLabel(title: 'Alterado por', value: data.user.nome),
        Gap(4),
        for (var item in data.statusProdutos.produtos)
          OrdemTimelineCardLabel(
            title: item.produto.descricaoReplaced,
            value: 'Movido para ${item.status.status.name}',
          ),
      ],
    );
  }
}
