import 'dart:convert';

import 'package:aco_plus/app/core/client/http/viacep/viacep_model.dart';
import 'package:aco_plus/app/core/extensions/text_controller_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';

class EnderecoModel {
  String cep = '';
  String logradouro = '';
  String bairro = '';
  String localidade = '';
  String estado = '';
  String numero = '';
  String complemento = '';
  double lat = 0.0;
  double lon = 0.0;
  EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.estado,
    required this.numero,
    required this.complemento,
    required this.lat,
    required this.lon,
  });

  EnderecoModel.empty();

  String get name => localidade.isEmpty
      ? 'Endereço Indisponível'
      : '$logradouro, $numero - $bairro. $localidade-${estado.toUpperCase()}';

  EnderecoModel.fromViacep(ViacepEndereco viacep) {
    cep = viacep.cep;
    logradouro = viacep.logradouro;
    bairro = viacep.bairro;
    localidade = viacep.localidade;
    estado = viacep.uf;
    complemento = viacep.complemento;
  }

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'localidade': localidade,
      'estado': estado,
      'numero': numero,
      'complemento': complemento,
      'lat': lat,
      'lon': lon,
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      bairro: map['bairro'] ?? '',
      localidade: map['localidade'] ?? '',
      estado: map['estado'] ?? '',
      numero: map['numero'] ?? '',
      complemento: map['complemento'] ?? '',
      lat: map['lat'] != null ? double.parse(map['lat'].toString()) : 0.0,
      lon: map['lon'] != null ? double.parse(map['lon'].toString()) : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String source) =>
      EnderecoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Endereco(cep: $cep, logradouro: $logradouro, bairro: $bairro, localidade: $localidade, uf: $estado, numero: $numero, complemento: $complemento, lat: $lat, lon: $lon)';
  }
}

class EnderecoCreateModel {
  final TextController cep = TextController.cep();
  final TextController logradouro = TextController();
  final TextController bairro = TextController();
  final TextController localidade = TextController();
  final TextController estado = TextController();
  final TextController numero = TextController();
  final TextController complemento = TextController();
  final TextController lat = TextController();
  final TextController lon = TextController();
  bool isEdit = false;

  EnderecoCreateModel();

  EnderecoCreateModel.fromViacep(ViacepEndereco viacep) {
    cep.text = viacep.cep;
    logradouro.text = viacep.logradouro;
    bairro.text = viacep.bairro;
    localidade.text = viacep.localidade;
    estado.text = viacep.uf;
  }

  EnderecoCreateModel.edit(EnderecoModel endereco) {
    isEdit = true;
    cep.text = endereco.cep;
    logradouro.text = endereco.logradouro;
    bairro.text = endereco.bairro;
    localidade.text = endereco.localidade;
    estado.text = endereco.estado;
    numero.text = endereco.numero;
    complemento.text = endereco.complemento;
    lat.text = endereco.lat.toString();
    lon.text = endereco.lon.toString();
  }

  EnderecoModel toEndereco() => EnderecoModel(
        cep: cep.text,
        logradouro: logradouro.text,
        bairro: bairro.text,
        localidade: localidade.text,
        estado: estado.text,
        numero: numero.text,
        complemento: complemento.text,
        lat: lat.doubleValue,
        lon: lon.doubleValue,
      );
}
