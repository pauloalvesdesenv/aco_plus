import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_criada_model.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem/components/timeline/ordem_timeline_card_label.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrdemTimelineCreateDetails extends StatelessWidget {
  final OrdemHistoryTypeCriadaModel data;

  const OrdemTimelineCreateDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrdemTimelineCardLabel(
          title: 'Criada por',
          value: data.user.nome,
        ),
        Gap(4),
        OrdemTimelineCardLabel(
          title: 'Matéria Prima',
          value: data.materiaPrima.label,
        ),
      ],
    );
  }
}
