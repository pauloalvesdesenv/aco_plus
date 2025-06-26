import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/produto/produto_controller.dart';
import 'package:aco_plus/app/modules/produto/produto_view_model.dart';
import 'package:flutter/material.dart';

class ProdutoCreatePage extends StatefulWidget {
  final ProdutoModel? produto;
  const ProdutoCreatePage({this.produto, super.key});

  @override
  State<ProdutoCreatePage> createState() => _ProdutoCreatePageState();
}

class _ProdutoCreatePageState extends State<ProdutoCreatePage> {
  @override
  void initState() {
    setWebTitle('Novo Produto');
    produtoCtrl.init(widget.produto);
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
              widget.produto != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do produto serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${produtoCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Produto',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async => await produtoCtrl.onConfirm(context, widget.produto),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: produtoCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(ProdutoCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.nome,
          onChanged: (_) => produtoCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Descrição',
          controller: form.descricao,
          onChanged: (_) => produtoCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Massa Final',
          controller: form.massaFinal,
          onChanged: (_) => produtoCtrl.formStream.update(),
          suffixText: 'Kg',
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
            onPressed: () => produtoCtrl.onDelete(context, widget.produto!),
            label: const Text('Excluir'),
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
