import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/checklist/checklist_controller.dart';
import 'package:aco_plus/app/modules/checklist/checklist_view_model.dart';
import 'package:aco_plus/app/modules/checklist/ui/checklist_create_page.dart';
import 'package:flutter/material.dart';

class ChecklistsPage extends StatefulWidget {
  const ChecklistsPage({super.key});

  @override
  State<ChecklistsPage> createState() => _ChecklistsPageState();
}

class _ChecklistsPageState extends State<ChecklistsPage> {
  @override
  void initState() {
    setWebTitle('Modelos de Checklist');
    checklistCtrl.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Modelos de checklists',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const ChecklistCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<ChecklistModel>>(
        stream: FirestoreClient.checklists.dataStream.listen,
        builder: (_, __) => StreamOut<ChecklistUtils>(
          stream: checklistCtrl.utilsStream.listen,
          builder: (_, utils) {
            final checklists = checklistCtrl
                .getChecklistsFiltered(utils.search.text, __)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => checklistCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: checklists.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async =>
                              FirestoreClient.checklists.fetch(),
                          child: ListView.separated(
                            itemCount: checklists.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemChecklistWidget(checklists[i]),
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

  ListTile _itemChecklistWidget(ChecklistModel checklist) {
    return ListTile(
      onTap: () => push(ChecklistCreatePage(checklist: checklist)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(checklist.nome, style: AppCss.mediumBold),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
