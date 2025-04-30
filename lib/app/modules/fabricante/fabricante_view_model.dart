import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class FabricanteUtils {
  final TextController search = TextController();
}

class FabricanteCreateModel {
  final String id;
  TextController nome = TextController();
  late bool isEdit;

  FabricanteCreateModel() : id = HashService.get, isEdit = false;

  FabricanteCreateModel.edit(FabricanteModel fabricante)
    : id = fabricante.id,
      isEdit = true {
    nome.text = fabricante.nome;
  }

  FabricanteModel toFabricanteModel() =>
      FabricanteModel(id: id, nome: nome.text);
}
