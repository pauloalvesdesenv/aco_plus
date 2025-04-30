enum UserPermissionType { create, read, update, delete }

extension UserPermissionTypeExtension on UserPermissionType {
  String get label {
    switch (this) {
      case UserPermissionType.create:
        return 'Criar';
      case UserPermissionType.read:
        return 'Ler';
      case UserPermissionType.update:
        return 'Atualizar';
      case UserPermissionType.delete:
        return 'Deletar';
    }
  }
}
