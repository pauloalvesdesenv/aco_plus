import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/enums/automatizacao_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

Future<StepModel?> showAutomatizacaoStepBottom(
  AutomatizacaoItemType type,
  StepModel step,
) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => AutomatizacaoStepBottom(step, type),
    );

class AutomatizacaoStepBottom extends StatefulWidget {
  final AutomatizacaoItemType type;
  final StepModel step;
  const AutomatizacaoStepBottom(this.step, this.type, {super.key});

  @override
  State<AutomatizacaoStepBottom> createState() =>
      _AutomatizacaoStepBottomState();
}

class _AutomatizacaoStepBottomState extends State<AutomatizacaoStepBottom> {
  late StepModel step;

  @override
  void initState() {
    step = widget.step;
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Container(
        height: 600,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const H(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.all(16),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.white,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      AppColors.black,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_backspace),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selecione a Etapa:', style: AppCss.largeBold),
                    Text(
                      '(${widget.type.desc})',
                      style: AppCss.minimumRegular,
                    ),
                    const H(16),
                    Expanded(
                      child: ListView(
                        children: [
                          for (StepModel e in FirestoreClient.steps.data)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: e.color.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: RadioListTile<StepModel>(
                                title: Text(
                                  e.name,
                                  style: AppCss.mediumRegular,
                                ),
                                value: e,
                                groupValue: step,
                                onChanged: (value) {
                                  setState(() {
                                    step = value!;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const H(16),
                    AppTextButton(
                      label: 'Confirmar',
                      onPressed: () => Navigator.pop(context, step),
                    ),
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
