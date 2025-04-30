import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/tag/tag_controller.dart';
import 'package:aco_plus/app/modules/tag/tag_view_model.dart';
import 'package:aco_plus/app/modules/tag/ui/tag_create_page.dart';
import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  void initState() {
    tagCtrl.onInit();
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
          'Etiquetas',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const TagCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<TagModel>>(
        stream: FirestoreClient.tags.dataStream.listen,
        builder: (_, __) => StreamOut<TagUtils>(
          stream: tagCtrl.utilsStream.listen,
          builder: (_, utils) {
            final tags =
                tagCtrl.getTagsFiltered(utils.search.text, __).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => tagCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: tags.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async => FirestoreClient.tags.fetch(),
                          child: ListView.separated(
                            itemCount: tags.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) => _itemTagWidget(tags[i]),
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

  ListTile _itemTagWidget(TagModel tag) {
    return ListTile(
      onTap: () => push(TagCreatePage(tag: tag)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(tag.nome, style: AppCss.mediumBold),
      subtitle: tag.descricao.isNotEmpty
          ? Text(tag.descricao, style: AppCss.minimumRegular)
          : null,
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: tag.color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.neutralMedium),
              ),
            ),
            const W(8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.neutralMedium,
            ),
          ],
        ),
      ),
    );
  }
}
