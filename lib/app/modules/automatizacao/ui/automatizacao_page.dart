import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/automatizacao/ui/automatizacao_step_bottom.dart';
import 'package:flutter/material.dart';

class AutomatizacaoPage extends StatefulWidget {
  const AutomatizacaoPage({super.key});

  @override
  State<AutomatizacaoPage> createState() => _AutomatizacaoPageState();
}

class _AutomatizacaoPageState extends State<AutomatizacaoPage> {
  @override
  void initState() {
    // automatizacaoCtrl.init(widget.automatizacao);
    super.initState();
  }

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
            (e) => Container(
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
                            e.type.label,
                            style: AppCss.mediumBold.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            e.type.desc,
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
                          e.type,
                          e.step,
                        );
                        if (step == null) return;
                        setState(() {
                          e.step = step;
                          FirestoreClient.automatizacao.update(automatizacao);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: e.step.color.withValues(alpha: 0.1),
                        ),
                        child: Row(
                          children: [
                            Text(
                              e.step.name,
                              style: AppCss.minimumRegular.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                            const W(8),
                            const Icon(
                              Icons.edit,
                              size: 17,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
