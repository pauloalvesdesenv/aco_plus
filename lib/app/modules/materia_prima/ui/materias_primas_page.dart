import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_controller.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_view_model.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_create_page.dart';
import 'package:flutter/material.dart';

class MateriasPrimasPage extends StatefulWidget {
  const MateriasPrimasPage({super.key});

  @override
  State<MateriasPrimasPage> createState() => _MateriasPrimasPageState();
}

class _MateriasPrimasPageState extends State<MateriasPrimasPage> {
  @override
  void initState() {
    FirestoreClient.materiaPrimas.fetch();
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
          'Materias Primas',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const MateriaPrimaCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<MateriaPrimaModel>>(
        stream: FirestoreClient.materiaPrimas.dataStream.listen,
        builder:
            (_, __) => StreamOut<MateriaPrimaUtils>(
              stream: materiaPrimaCtrl.utilsStream.listen,
              builder: (_, utils) {
                var materiaPrimas =
                    materiaPrimaCtrl
                        .getMateriaPrimaesFiltered(utils.search.text, __)
                        .toList();

                if (utils.status.isNotEmpty) {
                  materiaPrimas =
                      materiaPrimas
                          .where((e) => utils.status.contains(e.status))
                          .toList();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AppField(
                            hint: 'Pesquisar',
                            controller: utils.search,
                            suffixIcon: Icons.search,
                            onChanged:
                                (_) => materiaPrimaCtrl.utilsStream.update(),
                          ),
                          const H(16),
                          AppDropDownList<MateriaPrimaStatus>(
                            label: 'Status',
                            addeds: utils.status,
                            itens: MateriaPrimaStatus.values,
                            itemLabel: (e) => e.label,
                            itemColor: (e) => e.color,
                            onChanged:
                                () => materiaPrimaCtrl.utilsStream.update(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          materiaPrimas.isEmpty
                              ? const EmptyData()
                              : RefreshIndicator(
                                onRefresh:
                                    () async =>
                                        FirestoreClient.materiaPrimas.fetch(),
                                child: ListView.separated(
                                  itemCount: materiaPrimas.length,
                                  separatorBuilder: (_, i) => const Divisor(),
                                  itemBuilder:
                                      (_, i) => _itemMateriaPrimaWidget(
                                        materiaPrimas[i],
                                      ),
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

  Container _itemMateriaPrimaWidget(MateriaPrimaModel materiaPrima) {
    return Container(
      color:
          materiaPrima.status == MateriaPrimaStatus.disponivel
              ? Colors.white
              : Colors.grey.shade200,
      child: ListTile(
        onTap: () => push(MateriaPrimaCreatePage(materiaPrima: materiaPrima)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          materiaPrima.produto.labelMinified
              .replaceAll(' - ', ' ')
              .replaceAll('Bitola ', ''),
          style: AppCss.mediumBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fabricante: ${materiaPrima.fabricanteModel.nome}',
              style: AppCss.minimumRegular,
            ),
            Text(
              'Corrida/Lote: ${materiaPrima.corridaLote}',
              style: AppCss.minimumRegular,
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.neutralMedium,
        ),
      ),
    );
  }
}
