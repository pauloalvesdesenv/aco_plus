import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_item_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/automatizacao/ui/automatizacao_step_bottom.dart';
import 'package:aco_plus/app/modules/automatizacao/ui/automatizacao_steps_bottom.dart';
import 'package:flutter/material.dart';

class AutomatizacaoPage extends StatefulWidget {
  const AutomatizacaoPage({super.key});

  @override
  State<AutomatizacaoPage> createState() => _AutomatizacaoPageState();
}

class _AutomatizacaoPageState extends State<AutomatizacaoPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          'Automatização de Etapas',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: FirestoreClient.automatizacao.dataStream.listen,
        builder: (_, automatizacao) => body(automatizacao),
      ),
    );
  }

  Widget body(AutomatizacaoModel automatizacao) {
    return ListView(
      padding: EdgeInsets.zero,
      children: automatizacao.itens
          .map(
            (item) => item.steps == null && item.step != null
                ? _AutomatizacaoSingleWidget(
                    automatizacao: automatizacao,
                    automatizacaoItem: item,
                  )
                : _AutomatizacaoMultiplesWidget(
                    automatizacao: automatizacao,
                    automatizacaoItem: item,
                  ),
          )
          .toList(),
    );
  }
}

class _AutomatizacaoSingleWidget extends StatefulWidget {
  final AutomatizacaoModel automatizacao;
  final AutomatizacaoItemModel automatizacaoItem;
  const _AutomatizacaoSingleWidget({
    required this.automatizacao,
    required this.automatizacaoItem,
  });

  @override
  State<_AutomatizacaoSingleWidget> createState() =>
      _AutomatizacaoSingleWidgetState();
}

class _AutomatizacaoSingleWidgetState
    extends State<_AutomatizacaoSingleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]!, width: 0.5),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.automatizacaoItem.type.label,
                    style: AppCss.mediumBold.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    widget.automatizacaoItem.type.desc,
                    style: AppCss.minimumRegular.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final step = await showAutomatizacaoStepBottom(
                  widget.automatizacaoItem.type,
                  widget.automatizacaoItem.step!,
                );
                if (step == null) return;
                setState(() {
                  widget.automatizacaoItem.step = step;
                  FirestoreClient.automatizacao.update(widget.automatizacao);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.automatizacaoItem.step!.color.withValues(
                    alpha: 0.1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.automatizacaoItem.step!.name,
                      style: AppCss.minimumRegular.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    const W(8),
                    const Icon(Icons.edit, size: 17, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutomatizacaoMultiplesWidget extends StatefulWidget {
  final AutomatizacaoModel automatizacao;
  final AutomatizacaoItemModel automatizacaoItem;
  const _AutomatizacaoMultiplesWidget({
    required this.automatizacao,
    required this.automatizacaoItem,
  });

  @override
  State<_AutomatizacaoMultiplesWidget> createState() =>
      _AutomatizacaoMultiplesWidgetState();
}

class _AutomatizacaoMultiplesWidgetState
    extends State<_AutomatizacaoMultiplesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[400]!, width: 0.5),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.automatizacaoItem.type.label,
                    style: AppCss.mediumBold.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    widget.automatizacaoItem.type.desc,
                    style: AppCss.minimumRegular.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: widget.automatizacaoItem.steps!
                  .map(
                    (step) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: step.color.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      child: Text(
                        step.name,
                        style: AppCss.minimumRegular.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const W(8),
            InkWell(
              onTap: () async {
                final steps = await showAutomatizacaoStepsBottom(
                  widget.automatizacaoItem.steps!,
                );
                if (steps == null) return;
                setState(() {
                  widget.automatizacaoItem.steps = steps;
                  FirestoreClient.automatizacao.update(widget.automatizacao);
                });
              },
              child: const Icon(Icons.edit, size: 17, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
