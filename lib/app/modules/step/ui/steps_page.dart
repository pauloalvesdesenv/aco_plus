import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/step/step_controller.dart';
import 'package:aco_plus/app/modules/step/step_view_model.dart';
import 'package:aco_plus/app/modules/step/ui/step_create_page.dart';
import 'package:flutter/material.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  void initState() {
    stepCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Etapas',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const StepCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<StepModel>>(
        stream: FirestoreClient.steps.dataStream.listen,
        builder:
            (_, __) => StreamOut<StepUtils>(
              stream: stepCtrl.utilsStream.listen,
              builder: (_, utils) {
                final steps =
                    stepCtrl.getStepesFiltered(utils.search.text, __).toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppField(
                        hint: 'Pesquisar',
                        controller: utils.search,
                        suffixIcon: Icons.search,
                        onChanged: (_) => stepCtrl.utilsStream.update(),
                      ),
                    ),
                    Expanded(
                      child:
                          steps.isEmpty
                              ? const EmptyData()
                              : RefreshIndicator(
                                onRefresh:
                                    () async => FirestoreClient.steps.fetch(),
                                child: ReorderableListView(
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex)
                                      newIndex = newIndex - 1;
                                    final step = steps.removeAt(oldIndex);
                                    steps.insert(newIndex, step);
                                    for (var i = 0; i < steps.length; i++) {
                                      steps[i].index = i;
                                      FirestoreClient.steps.dataStream.update();
                                      FirestoreClient.steps.update(steps[i]);
                                    }
                                  },
                                  children:
                                      steps
                                          .map((e) => _itemStepWidget(e))
                                          .toList(),
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

  Widget _itemStepWidget(StepModel step) {
    return Material(
      color: const Color(0xFFF7FCFC),
      key: ValueKey(step),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.neutralLight)),
        ),
        child: InkWell(
          onTap: () => push(StepCreatePage(step: step)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: step.color,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.neutralMedium),
                  ),
                ),
                const W(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(step.name, style: AppCss.mediumBold),
                          const W(4),
                          if (step.isDefault)
                            Container(
                              margin: const EdgeInsets.only(left: 3),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryMain,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Padrão',
                                style: AppCss.minimumBold
                                    .setColor(AppColors.white)
                                    .setSize(11),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Permissão: ${step.moveRoles.map((e) => e.label).join(', ')}',
                        style: AppCss.minimumRegular.setSize(11),
                      ),
                      const H(2),
                      Text(
                        'Criado em ${step.createdAt.textHour()}',
                        style: AppCss.minimumRegular
                            .setSize(10)
                            .setColor(Colors.grey),
                      ),
                    ],
                  ),
                ),
                const W(8),
                const W(25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
