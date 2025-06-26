import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_drop_down_list.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_view_model.dart';
import 'package:flutter/material.dart';

class UsuarioCreatePage extends StatefulWidget {
  final UsuarioModel? usuario;
  const UsuarioCreatePage({this.usuario, super.key});

  @override
  State<UsuarioCreatePage> createState() => _UsuarioCreatePageState();
}

class _UsuarioCreatePageState extends State<UsuarioCreatePage> {
  @override
  void initState() {
    setWebTitle('Novo Usuário');
    usuarioCtrl.init(widget.usuario);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${usuarioCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Usuario',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(
            () async => await usuarioCtrl.onConfirm(context, widget.usuario),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: usuarioCtrl.formStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(UsuarioCreateModel form) {
    return RefreshIndicator(
      onRefresh: () async => await FirestoreClient.usuarios.fetch(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppField(
            label: 'Nome',
            controller: form.nome,
            onChanged: (_) => usuarioCtrl.formStream.update(),
          ),
          const H(16),
          AppField(
            label: 'E-mail',
            controller: form.email,
            onChanged: (_) => usuarioCtrl.formStream.update(),
          ),
          const H(16),
          AppField(
            label: 'Senha',
            controller: form.senha,
            onChanged: (_) => usuarioCtrl.formStream.update(),
          ),
          const H(16),
          AppDropDown<UsuarioRole?>(
            label: 'Tipo',
            item: form.role,
            itens: UsuarioRole.values,
            itemLabel: (e) => e?.label ?? 'Selecione',
            onSelect: (e) {
              form.role = e;
              if (e == UsuarioRole.operador) {
                form.permission.cliente = [];
                form.permission.pedido = [];
                form.permission.ordem = [
                  UserPermissionType.read,
                  UserPermissionType.update,
                ];
              } else {
                form.permission.cliente = UserPermissionType.values;
                form.permission.pedido = UserPermissionType.values;
                form.permission.ordem = UserPermissionType.values;
              }
              usuarioCtrl.formStream.update();
            },
          ),
          const H(16),
          if (form.role != UsuarioRole.operador) ...[
            AppDropDownList<UserPermissionType>(
              label: 'Permissões de Cliente',
              itens: UserPermissionType.values,
              addeds: form.permission.cliente,
              onChanged: () {
                usuarioCtrl.formStream.update();
              },
              itemLabel: (e) => e.label,
            ),
            const H(16),
            AppDropDownList<UserPermissionType>(
              label: 'Permissões de Pedidos',
              itens: UserPermissionType.values,
              addeds: form.permission.pedido,
              onChanged: () {
                usuarioCtrl.formStream.update();
              },
              itemLabel: (e) => e.label,
            ),
            const H(16),
            AppDropDownList<UserPermissionType>(
              label: 'Permissões de Ordens',
              itens: UserPermissionType.values,
              addeds: form.permission.ordem,
              onChanged: () {
                usuarioCtrl.formStream.update();
              },
              itemLabel: (e) => e.label,
            ),
          ],
          if (form.role == UsuarioRole.operador) ...[
            Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Operadores podem visualizar apenas ordens pendentes',
                      style: TextStyle(color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              onPressed: () => usuarioCtrl.onDelete(context, widget.usuario!),
              label: const Text('Excluir'),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    );
  }
}
