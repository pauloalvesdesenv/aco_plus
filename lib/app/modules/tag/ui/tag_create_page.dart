import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/components/app_color_picker.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/tag/tag_controller.dart';
import 'package:aco_plus/app/modules/tag/tag_view_model.dart';
import 'package:flutter/material.dart';

class TagCreatePage extends StatefulWidget {
  final TagModel? tag;
  const TagCreatePage({this.tag, super.key});

  @override
  State<TagCreatePage> createState() => _TagCreatePageState();
}

class _TagCreatePageState extends State<TagCreatePage> {
  @override
  void initState() {
    tagCtrl.init(widget.tag);
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
              widget.tag != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do Etapa serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${tagCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Etiqueta',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async => await tagCtrl.onConfirm(context, widget.tag),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: tagCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(TagCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.nome,
          onChanged: (_) => tagCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Descrição',
          controller: form.descricao,
          onChanged: (_) => tagCtrl.formStream.update(),
        ),
        const H(16),
        AppColorPicker(
          label: 'Cor:',
          color: form.color,
          onChanged: (e) {
            form.color = e;
            tagCtrl.formStream.update();
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
            onPressed: () => tagCtrl.onDelete(context, widget.tag!),
            label: const Text('Excluir'),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
