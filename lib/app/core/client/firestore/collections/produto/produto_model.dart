import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class ProdutoModel {
  final String id;
  final String nome;
  final String descricao;
  final double massaFinal;

  factory ProdutoModel.empty() => ProdutoModel(
      id: HashService.get,
      nome: 'Produto não encontrado',
      descricao: 'Este produto não foi encontrado no sistema',
      massaFinal: 0.0);

  String get descricaoReplaced =>
      descricao.replaceAll('mm', '').replaceAll('.0', '');

  double get number =>
      double.tryParse(descricao.substring(0, descricao.length - 2)) ?? 0.0;

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.massaFinal,
  });

  String get label => '$nome - $descricao - $massaFinal';

  String get labelMinified => '$nome - $descricao';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'massaFinal': massaFinal,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      massaFinal: double.tryParse(map['massaFinal'].toString()) ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoModel.fromJson(String source) =>
      ProdutoModel.fromMap(json.decode(source));

  ProdutoModel copyWith({
    String? id,
    String? nome,
    String? descricao,
    FabricanteModel? fabricante,
    double? massaFinal,
  }) {
    return ProdutoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      massaFinal: massaFinal ?? this.massaFinal,
    );
  }
}
