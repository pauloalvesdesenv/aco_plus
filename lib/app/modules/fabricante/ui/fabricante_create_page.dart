import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/fabricante/fabricante_controller.dart';
import 'package:aco_plus/app/modules/fabricante/fabricante_view_model.dart';
import 'package:flutter/material.dart';

class FabricanteCreatePage extends StatefulWidget {
  final FabricanteModel? fabricante;
  const FabricanteCreatePage({this.fabricante, super.key});

  @override
  State<FabricanteCreatePage> createState() => _FabricanteCreatePageState();
}

class _FabricanteCreatePageState extends State<FabricanteCreatePage> {
  @override
  void initState() {
    fabricanteCtrl.init(widget.fabricante);
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
              widget.fabricante != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do fabricante serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${fabricanteCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Fabricante',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async =>
                await fabricanteCtrl.onConfirm(context, widget.fabricante),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: fabricanteCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(FabricanteCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.nome,
          onChanged: (_) => fabricanteCtrl.formStream.update(),
        ),
        const H(16),
        if (form.isEdit)
          TextButton.icon(
            style: ButtonStyle(
              fixedSize: const WidgetStatePropertyAll(
                Size.fromWidth(double.maxFinite),
              ),
              foregroundColor: WidgetStatePropertyAll(AppColors.error),
              backgroundColor: WidgetStatePropertyAll(AppColors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: AppCss.radius8,
                  side: BorderSide(color: AppColors.error),
                ),
              ),
            ),
            onPressed:
                () => fabricanteCtrl.onDelete(context, widget.fabricante!),
            label: const Text('Excluir'),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
