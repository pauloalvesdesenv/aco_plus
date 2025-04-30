import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/archive/ui/archives_widget.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_controller.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MateriaPrimaCreatePage extends StatefulWidget {
  final MateriaPrimaModel? materiaPrima;
  const MateriaPrimaCreatePage({this.materiaPrima, super.key});

  @override
  State<MateriaPrimaCreatePage> createState() => _MateriaPrimaCreatePageState();
}

class _MateriaPrimaCreatePageState extends State<MateriaPrimaCreatePage> {
  @override
  void initState() {
    materiaPrimaCtrl.init(widget.materiaPrima);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        resizeAvoid: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                if (await showConfirmDialog(
                    'Deseja realmente sair?',
                    widget.materiaPrima != null
                        ? 'A edição que realizou será perdida'
                        : 'Os dados da Matéria Prima serão perdidos.')) {
                  pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              )),
          title: Text(
              '${materiaPrimaCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Matéria Prima',
              style: AppCss.largeBold.setColor(AppColors.white)),
          actions: [
            IconLoadingButton(() async =>
                await materiaPrimaCtrl.onConfirm(context, widget.materiaPrima))
          ],
          backgroundColor: AppColors.primaryMain,
        ),
        body: StreamOut(
            stream: materiaPrimaCtrl.formStream.listen,
            builder: (_, form) => body(form)));
  }

  Widget body(MateriaPrimaCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppDropDown<FabricanteModel?>(
          label: 'Fabricante',
          item: form.fabricanteModel,
          itens: FirestoreClient.fabricantes.data,
          itemLabel: (item) => item!.nome,
          onSelect: (item) {
            form.fabricanteModel = item;
            materiaPrimaCtrl.formStream.update();
          },
        ),
        const H(16),
        Builder(builder: (context) {
          final produtos =
              materiaPrimaCtrl.getProdutosAvailable(form.fabricanteModel);
          return AppDropDown<ProdutoModel?>(
            label: 'Produto',
            item:
                produtos.firstWhereOrNull((e) => e.id == form.produtoModel?.id),
            disable: form.fabricanteModel == null,
            itens: produtos,
            itemLabel: (item) => item!.labelMinified,
            onSelect: (item) {
              form.produtoModel = item;
              materiaPrimaCtrl.formStream.update();
            },
          );
        }),
        const H(16),
        AppField(
          label: 'Corrida/Lote',
          controller: form.corridaLote,
          onChanged: (_) => materiaPrimaCtrl.formStream.update(),
        ),
        const H(16),
        AppDropDown<MateriaPrimaStatus?>(
          label: 'Status',
          item: form.status,
          itens: MateriaPrimaStatus.values,
          itemLabel: (item) => item!.label,
          onSelect: (item) {
            form.status = item!;
            materiaPrimaCtrl.formStream.update();
          },
        ),
        const H(16),
        ArchivesWidget(
          path: 'materia_primas/${form.id}',
          archives: form.anexos,
          onChanged: () => materiaPrimaCtrl.formStream.update(),
        ),
        const H(16),
        if (form.isEdit)
          TextButton.icon(
              style: ButtonStyle(
                fixedSize: const WidgetStatePropertyAll(
                    Size.fromWidth(double.maxFinite)),
                foregroundColor: WidgetStatePropertyAll(AppColors.error),
                backgroundColor: WidgetStatePropertyAll(AppColors.white),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: AppCss.radius8,
                    side: BorderSide(color: AppColors.error))),
              ),
              onPressed: () =>
                  materiaPrimaCtrl.onDelete(context, widget.materiaPrima!),
              label: const Text('Excluir'),
              icon: const Icon(
                Icons.delete_outline,
              )),
      ],
    );
  }
}
