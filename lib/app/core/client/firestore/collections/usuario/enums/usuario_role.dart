enum UsuarioRole {
  administrador,
  coordenador,
  planilhador,
  vendedor,
  cliente,
  operador,
}

extension UsuarioRoleExtension on UsuarioRole {
  String? get label {
    switch (this) {
      case UsuarioRole.administrador:
        return 'Administrador';
      case UsuarioRole.coordenador:
        return 'Coordenador';
      case UsuarioRole.planilhador:
        return 'Planilhador';
      case UsuarioRole.vendedor:
        return 'Vendedor';
      case UsuarioRole.cliente:
        return 'Cliente';
      case UsuarioRole.operador:
        return 'Operador';
    }
  }
}
