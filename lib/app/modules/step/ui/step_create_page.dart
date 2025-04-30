import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_checkbox.dart';
import 'package:aco_plus/app/core/components/app_color_picker.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/step/step_controller.dart';
import 'package:aco_plus/app/modules/step/step_shipping_view_model.dart';
import 'package:aco_plus/app/modules/step/step_view_model.dart';
import 'package:flutter/material.dart';

class StepCreatePage extends StatefulWidget {
  final StepModel? step;
  const StepCreatePage({this.step, super.key});

  @override
  State<StepCreatePage> createState() => _StepCreatePageState();
}

class _StepCreatePageState extends State<StepCreatePage> {
  @override
  void initState() {
    stepCtrl.init(widget.step);
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
              widget.step != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do Etapa serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${stepCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Etapa',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async => await stepCtrl.onConfirm(context, widget.step),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: stepCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(StepCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.name,
          onChanged: (_) => stepCtrl.formStream.update(),
        ),
        const H(16),
        AppColorPicker(
          label: 'Cor:',
          color: form.color,
          onChanged: (e) {
            form.color = e;
            stepCtrl.formStream.update();
          },
        ),
        const H(16),
        AppDropDownList<StepModel>(
          label: 'Recebe de',
          addeds: form.fromSteps,
          itens:
              FirestoreClient.steps.data.where((e) => e.id != form.id).toList(),
          itemLabel: (e) => e.name,
          onChanged: () {
            stepCtrl.formStream.add(form);
          },
        ),
        const H(16),
        AppDropDownList<UsuarioRole>(
          label: 'Movido por',
          addeds: form.moveRoles,
          itens: UsuarioRole.values,
          itemLabel: (e) => e.label ?? 'Selecione',
          onChanged: () {
            stepCtrl.formStream.add(form);
          },
        ),
        const H(16),
        AppCheckbox(
          value: form.isShipping,
          label: 'Acompanhamento do Cliente',
          onChanged: (e) {
            form.isShipping = e;
            if (form.isShipping) {
              form.shipping = StepShippingCreateModel();
            } else {
              form.shipping = null;
            }
            stepCtrl.formStream.update();
          },
        ),
        if (form.isShipping) ...[
          const H(16),
          AppField(
            label: 'Texto de Acompanhamento',
            controller: form.shipping!.description,
            onChanged: (_) => stepCtrl.formStream.update(),
          ),
          const H(16),
        ],
        const H(8),
        AppCheckbox(
          value: form.isArchivedAvailable,
          label: 'Permite arquivamento de pedidos',
          onChanged: (e) {
            form.isArchivedAvailable = !form.isArchivedAvailable;
            stepCtrl.formStream.update();
          },
        ),
        const H(8),
        AppCheckbox(
          value: form.isPermiteProducao,
          label: 'Permite Entrada em Produção',
          onChanged: (e) {
            form.isPermiteProducao = !form.isPermiteProducao;
            stepCtrl.formStream.update();
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
            onPressed: () => stepCtrl.onDelete(context, widget.step!),
            label: const Text('Excluir'),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
