import 'dart:convert';

class Credential {
  final String cpf;
  final String password;
  bool isEmpty = true;
  Credential({required this.cpf, required this.password}) : isEmpty = false;

  Credential.empty() : cpf = '', password = '', isEmpty = true;

  Map<String, dynamic> toMap() {
    return {'cpf': cpf, 'password': password};
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(cpf: map['cpf'] ?? '', password: map['password'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source));
}
