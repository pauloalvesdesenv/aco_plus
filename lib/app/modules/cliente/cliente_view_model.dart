import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class ClienteUtils {
  final TextController search = TextController();
}

class ClienteCreateModel {
  final String id;
  TextController nome = TextController();
  TextController telefone = TextController.phone();
  TextController cpf = TextController(mask: '00000000000000000');
  EnderecoModel? endereco;
  List<ObraModel> obras = [];
  late bool isEdit;

  ClienteCreateModel()
      : id = HashService.get,
        isEdit = false;

  ClienteCreateModel.edit(ClienteModel cliente)
      : id = cliente.id,
        isEdit = true {
    nome.text = cliente.nome;
    telefone.text = cliente.telefone;
    cpf.text = cliente.cpf;
    endereco = cliente.endereco;
    obras = cliente.obras;
    if (CPFValidator.isValid(cpf.text)) {
      cpf.updateMask('000.000.000-00');
    }
    if (CNPJValidator.isValid(cpf.text)) {
      cpf.updateMask('00.000.000/0000-00');
    }
  }

  ClienteModel toClienteModel() => ClienteModel(
        id: id,
        nome: nome.text,
        telefone: telefone.text,
        cpf: cpf.text,
        endereco: endereco ?? EnderecoModel.empty(),
        obras: obras,
      );
}
