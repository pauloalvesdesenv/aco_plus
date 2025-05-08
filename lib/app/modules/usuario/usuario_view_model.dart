import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_permission_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class UsuarioUtils {
  final TextController search = TextController();
}

class UsuarioCreateModel {
  final String id;
  TextController nome = TextController();
  TextController email = TextController();
  TextController senha = TextController();
  UsuarioPermissionCreateModel permission = UsuarioPermissionCreateModel();
  UsuarioRole? role;
  late bool isEdit;

  UsuarioCreateModel() : id = HashService.get, isEdit = false;

  UsuarioCreateModel.edit(UsuarioModel user) : id = user.id, isEdit = true {
    nome.text = user.nome;
    email.text = user.email;
    role = user.role;
    senha.text = user.senha;
    permission = UsuarioPermissionCreateModel.edit(user);
  }

  UsuarioModel toUsuarioModel() => UsuarioModel(
    id: id,
    nome: nome.text,
    email: email.text,
    role: role!,
    senha: senha.text,
    permission: permission.toUserPermissionModel(),
    steps: [],
    deviceTokens: [],
  );
}

class UsuarioPermissionCreateModel {
  final String id;
  List<UserPermissionType> cliente = UserPermissionType.values.toList();
  List<UserPermissionType> pedido = UserPermissionType.values.toList();
  List<UserPermissionType> ordem = UserPermissionType.values.toList();
  late bool isEdit;

  UsuarioPermissionCreateModel() : id = HashService.get, isEdit = false;

  UsuarioPermissionCreateModel.edit(UsuarioModel user)
    : id = user.id,
      isEdit = true {
    cliente = user.permission.cliente;
    pedido = user.permission.pedido;
    ordem = user.permission.ordem;
  }

  UserPermissionModel toUserPermissionModel() =>
      UserPermissionModel(cliente: cliente, pedido: pedido, ordem: ordem);
}
