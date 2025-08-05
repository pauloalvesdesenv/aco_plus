import 'dart:convert';

import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class ClienteModel {
  final String id;
  final String nome;
  final String telefone;
  final String cpf;
  final EnderecoModel endereco;
  final List<ObraModel> obras;
  ClienteModel({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cpf,
    required this.endereco,
    required this.obras,
  });

  factory ClienteModel.empty() => ClienteModel(
    id: HashService.get,
    nome: 'name',
    telefone: 'fone',
    cpf: 'cpf',
    endereco: EnderecoModel.empty(),
    obras: [],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'cpf': cpf,
      'endereco': endereco.toMap(),
      'obras': obras.map((x) => x.toMap()).toList(),
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      cpf: map['cpf'] ?? '',
      endereco: EnderecoModel.fromMap(map['endereco']),
      obras: List<ObraModel>.from(
        map['obras']?.map((x) => ObraModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClienteModel.fromJson(String source) =>
      ClienteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClienteModel(id: $id, nome: $nome, telefone: $telefone, cpf: $cpf, endereco: $endereco, obras: $obras)';
  }
}

class ObraModel {
  final String id;
  final String descricao;
  final String telefoneFixo;
  EnderecoModel? endereco;
  final ObraStatus status;

  factory ObraModel.empty() => ObraModel(
    id: HashService.get,
    descricao: 'name',
    telefoneFixo: 'fone',
    endereco: null,
    status: ObraStatus.emAndamento,
  );

  ObraModel({
    required this.id,
    required this.descricao,
    required this.telefoneFixo,
    required this.endereco,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'telefoneFixo': telefoneFixo,
      'endereco': endereco?.toMap(),
      'status': status.index,
    };
  }

  factory ObraModel.fromMap(Map<String, dynamic> map) {
    return ObraModel(
      id: map['id'] ?? '',
      descricao: map['descricao'] ?? '',
      telefoneFixo: map['telefoneFixo'] ?? '',
      endereco: map['endereco'] != null
          ? EnderecoModel.fromMap(map['endereco'])
          : null,
      status: ObraStatus.values[map['status']],
    );
  }

  String toJson() => json.encode(toMap());

  factory ObraModel.fromJson(String source) =>
      ObraModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ObraModel(id: $id, descricao: $descricao, telefoneFixo: $telefoneFixo, endereco: $endereco, status: $status)';
  }
}

ObraModel obraDeleteObj = ObraModel(
  id: 'delete',
  descricao: '',
  endereco: null,
  status: ObraStatus.emAndamento,
  telefoneFixo: '',
);

class ClienteAdd extends ClienteModel {
  ClienteAdd()
    : super(
        id: 'add',
        nome: 'ADICIONAR CLIENTE',
        telefone: '',
        cpf: '',
        endereco: EnderecoModel.empty(),
        obras: [],
      );
}
