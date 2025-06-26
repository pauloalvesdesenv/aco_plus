import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_multiple_registers.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/cliente_controller.dart';
import 'package:aco_plus/app/modules/cliente/cliente_view_model.dart';
import 'package:aco_plus/app/modules/endereco/endereco_create_page.dart';
import 'package:aco_plus/app/modules/obra/ui/obra_create_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

class ClienteCreatePage extends StatefulWidget {
  final ClienteModel? cliente;
  final bool isFromOrder;
  const ClienteCreatePage({this.cliente, this.isFromOrder = false, super.key});

  @override
  State<ClienteCreatePage> createState() => _ClienteCreatePageState();
}

class _ClienteCreatePageState extends State<ClienteCreatePage> {
  @override
  void initState() {
    setWebTitle('Novo Cliente');
    clienteCtrl.init(widget.cliente);
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
              widget.cliente != null
                  ? 'A edição que realizou será perdida'
                  : 'Os dados do cliente serão perdidos.',
            )) {
              pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${clienteCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Cliente',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          if ((widget.cliente != null &&
                  usuario.permission.cliente.contains(
                    UserPermissionType.update,
                  )) ||
              (widget.cliente == null &&
                  usuario.permission.cliente.contains(
                    UserPermissionType.create,
                  )))
            IconLoadingButton(
              () async => await clienteCtrl.onConfirm(
                context,
                widget.cliente,
                widget.isFromOrder,
              ),
            ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: clienteCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(ClienteCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'Nome',
          controller: form.nome,
          onChanged: (_) => clienteCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Telefone',
          hint: '(00) 00000-000',
          controller: form.telefone,
          onChanged: (_) => clienteCtrl.formStream.update(),
        ),
        const H(16),
        AppField(
          label: 'CPF/CNPJ',
          required: false,
          controller: form.cpf,
          onChanged: (value) {
            if (value.length == 11 && CPFValidator.isValid(form.cpf.text)) {
              form.cpf.updateMask('000.000.000-00');
            } else if (value.length == 14 &&
                CNPJValidator.isValid(form.cpf.text)) {
              form.cpf.updateMask('00.000.000/0000-00');
            } else {
              form.cpf.updateMask('00000000000000000');
            }
            clienteCtrl.formStream.update();
          },
        ),
        const H(16),
        InkWell(
          onTap: () async {
            final endereco = await push(
              context,
              EnderecoCreatePage(endereco: form.endereco),
            );
            if (endereco != null) {
              form.endereco = endereco;
              clienteCtrl.formStream.update();
            }
          },
          child: IgnorePointer(
            child: AppField(
              label: 'Endereço',
              required: false,
              suffixIconSize: 12,
              suffixIcon: Icons.arrow_forward_ios,
              controller: TextController(
                text: form.endereco?.name.toString() ?? '',
              ),
              onChanged: (_) => clienteCtrl.formStream.update(),
              hint: 'Clique para adicionar',
            ),
          ),
        ),
        const H(16),
        AppMultipleRegisters<ObraModel>(
          icon: Icons.construction,
          title: 'Obras ',
          createPage: ObraCreatePage(endereco: form.endereco),
          onEdit: (obraForm) async {
            ObraModel? obra = await push(
              context,
              ObraCreatePage(obra: obraForm),
            );
            if (obra != null) {
              final i = form.obras
                  .map((e) => e.id)
                  .toList()
                  .indexOf(obraForm.id);
              if (obra.id != 'delete') {
                form.obras[i] = obra;
              } else {
                form.obras.removeAt(i);
              }
            }
            clienteCtrl.formStream.update();
          },
          onAdd: (e) {
            form.obras.add(e);
            clienteCtrl.formStream.update();
          },
          itens: form.obras,
          titleBuilder: (e) => Row(
            children: [
              Text(e.descricao, style: AppCss.minimumRegular),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: e.status.color.withValues(alpha: 0.5),
                  borderRadius: AppCss.radius4,
                ),
                child: Text(
                  e.status.label,
                  style: AppCss.minimumBold.setSize(11),
                ),
              ),
            ],
          ),
        ),
        const H(24),
        if (usuario.permission.cliente.contains(UserPermissionType.delete))
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
              onPressed: () => clienteCtrl.onDelete(context, widget.cliente!),
              label: const Text('Excluir'),
              icon: const Icon(Icons.delete_outline),
            ),
      ],
    );
  }
}
