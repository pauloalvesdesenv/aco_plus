import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

Future<void> showPedidoUsersBottom(PedidoModel pedido) async {
  List<UsuarioModel>? selectedUsers = await showModalBottomSheet(
    backgroundColor: AppColors.white,
    context: contextGlobal,
    isScrollControlled: true,
    builder: (_) => PedidoUsersBottom(pedido),
  );
  if (selectedUsers != null) {
    pedidoCtrl.setPedidoUsuarios(pedido, selectedUsers);
  }
}

class PedidoUsersBottom extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoUsersBottom(this.pedido, {super.key});

  @override
  State<PedidoUsersBottom> createState() => _PedidoUsersBottomState();
}

class _PedidoUsersBottomState extends State<PedidoUsersBottom> {
  late List<UsuarioModel> selectedUsers;

  @override
  void initState() {
    pedidoCtrl.setPedido(widget.pedido);
    selectedUsers = widget.pedido.users.toList();
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Container(
        height: 600,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                    backgroundColor: WidgetStatePropertyAll(AppColors.white),
                    foregroundColor: WidgetStatePropertyAll(AppColors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_backspace),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text('Adicionar Membros', style: AppCss.largeBold),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: FirestoreClient.usuarios.data.toList().map((user) {
                  bool isCurrentUser = user.id == usuario.id;
                  bool isEnable =
                      isCurrentUser ||
                      !widget.pedido.users.map((e) => e.id).contains(user.id);
                  return IgnorePointer(
                    ignoring: !isEnable,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isEnable ? Colors.grey[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: false,
                        activeColor: isEnable ? null : Colors.grey[600],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        secondary: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: AppAvatar(
                            backgroundColor: Colors.grey[200],
                            name: user.nome,
                            radius: 16,
                          ),
                        ),
                        title: Text(
                          user.nome,
                          style: AppCss.mediumRegular.copyWith(
                            color: isEnable ? null : Colors.grey[600],
                          ),
                        ),
                        value: selectedUsers.map((e) => e.id).contains(user.id),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              selectedUsers.add(user);
                            } else {
                              selectedUsers.removeWhere((e) => e.id == user.id);
                            }
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppTextButton(
                label: 'Confirmar',
                onPressed: () => Navigator.pop(context, selectedUsers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
