import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/fabricante/fabricante_controller.dart';
import 'package:aco_plus/app/modules/fabricante/fabricante_view_model.dart';
import 'package:aco_plus/app/modules/fabricante/ui/fabricante_create_page.dart';
import 'package:flutter/material.dart';

class FabricantesPage extends StatefulWidget {
  const FabricantesPage({super.key});

  @override
  State<FabricantesPage> createState() => _FabricantesPageState();
}

class _FabricantesPageState extends State<FabricantesPage> {
  @override
  void initState() {
    FirestoreClient.fabricantes.fetch();
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
          'Fabricantes',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => push(context, const FabricanteCreatePage()),
              icon: Icon(
                Icons.add,
                color: AppColors.white,
              ))
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<FabricanteModel>>(
        stream: FirestoreClient.fabricantes.dataStream.listen,
        builder: (_, __) => StreamOut<FabricanteUtils>(
          stream: fabricanteCtrl.utilsStream.listen,
          builder: (_, utils) {
            final fabricantes = fabricanteCtrl
                .getFabricanteesFiltered(utils.search.text, __)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => fabricanteCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: fabricantes.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async =>
                              FirestoreClient.fabricantes.fetch(),
                          child: ListView.separated(
                            itemCount: fabricantes.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemFabricanteWidget(fabricantes[i]),
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

  ListTile _itemFabricanteWidget(FabricanteModel usuario) {
    return ListTile(
      onTap: () => push(FabricanteCreatePage(fabricante: usuario)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(usuario.nome, style: AppCss.mediumBold),
      // subtitle: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       'Tel: ${usuario.telefone} - Qtd. Obras: ${usuario.obras.length}',
      //     ),
      //     Text(
      //       usuario.endereco.name,
      //       style: AppCss.minimumRegular
      //           .setSize(12)
      //           .setColor(AppColors.neutralMedium),
      //     ),
      //   ],
      // ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
