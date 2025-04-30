enum UserActionType { create, read, update, delete }

extension UserActionTypeExtension on UserActionType {
  String get label {
    switch (this) {
      case UserActionType.create:
        return 'Criar';
      case UserActionType.read:
        return 'Ler';
      case UserActionType.update:
        return 'Atualizar';
      case UserActionType.delete:
        return 'Deletar';
    }
  }
}
