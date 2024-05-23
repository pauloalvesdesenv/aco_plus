import 'dart:convert';

class ProdutoModel {
  final String id;
  final String nome;
  final String descricao;

  String get descricaoReplaced => descricao.replaceAll('mm', '').replaceAll('.0', '');

  double get number => double.parse(descricao.substring(0, descricao.length - 2));

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  String get label => '$nome - $descricao';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoModel.fromJson(String source) => ProdutoModel.fromMap(json.decode(source));
}
