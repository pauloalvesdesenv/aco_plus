class FabricanteModel {
  final String id;
  final String nome;

  FabricanteModel({required this.id, required this.nome});

  static FabricanteModel empty() =>
      FabricanteModel(id: 'register_unavailable', nome: 'Sem Registro');

  factory FabricanteModel.fromMap(Map<String, dynamic> map) {
    return FabricanteModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }
}
