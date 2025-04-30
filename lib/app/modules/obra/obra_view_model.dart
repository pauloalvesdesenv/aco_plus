import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class ObraUtils {
  final TextController search = TextController();
}

class ObraCreateModel {
  final String id;
  TextController descricao = TextController();
  TextController telefoneFixo = TextController.phone();
  EnderecoModel? endereco;
  ObraStatus? status = ObraStatus.emAndamento;
  late bool isEdit;

  ObraCreateModel()
      : id = HashService.get,
        isEdit = false;

  ObraCreateModel.edit(ObraModel obra)
      : id = obra.id,
        isEdit = true {
    descricao.text = obra.descricao;
    endereco = obra.endereco;
    status = obra.status;
  }

  ObraModel toObraModel() => ObraModel(
        id: id,
        descricao: descricao.text,
        endereco: endereco,
        status: status!,
        telefoneFixo: telefoneFixo.text,
      );
}
