import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/checklist/check_list_widget.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/checklist/checklist_controller.dart';
import 'package:aco_plus/app/modules/checklist/checklist_view_model.dart';
import 'package:flutter/material.dart';

class ChecklistCreatePage extends StatefulWidget {
  final ChecklistModel? checklist;
  const ChecklistCreatePage({this.checklist, super.key});

  @override
  State<ChecklistCreatePage> createState() => _ChecklistCreatePageState();
}

class _ChecklistCreatePageState extends State<ChecklistCreatePage> {
  @override
  void initState() {
    setWebTitle('Novo Modelo de Checklist');
    checklistCtrl.init(widget.checklist);
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
              widget.checklist != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do Checklist serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${checklistCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Etiqueta',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async =>
                await checklistCtrl.onConfirm(context, widget.checklist),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: checklistCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(ChecklistCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.nome,
          onChanged: (_) => checklistCtrl.formStream.update(),
        ),
        const H(16),
        CheckListWidget(
          items: form.checklist,
          onChanged: (item) => checklistCtrl.formStream.update(),
          onAdd: (item) {
            form.checklist.add(item);
            checklistCtrl.formStream.update();
          },
          onRemove: (item) {
            form.checklist.remove(item);
            checklistCtrl.formStream.update();
          },
        ),
        const H(24),
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
            onPressed: () => checklistCtrl.onDelete(context, widget.checklist!),
            label: const Text('Excluir'),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
