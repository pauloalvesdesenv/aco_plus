import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/archive/archive_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class MateriaPrimaUtils {
  final TextController search = TextController();
}

class MateriaPrimaCreateModel {
  final String id;
  FabricanteModel? fabricanteModel;
  ProdutoModel? produtoModel;
  TextController corridaLote = TextController();
  List<ArchiveModel> anexos = [];
  MateriaPrimaStatus status = MateriaPrimaStatus.disponivel;

  late bool isEdit;

  MateriaPrimaCreateModel() : id = HashService.get, isEdit = false;

  MateriaPrimaCreateModel.edit(MateriaPrimaModel materiaPrima)
      : id = materiaPrima.id,
        isEdit = true {
    fabricanteModel =
        FirestoreClient.fabricantes.getById(materiaPrima.fabricanteModel.id);
    produtoModel = FirestoreClient.produtos.getById(materiaPrima.produto.id);
    corridaLote.text = materiaPrima.corridaLote;
    anexos = materiaPrima.anexos;
    status = materiaPrima.status;
  }

  MateriaPrimaModel toMateriaPrimaModel() => MateriaPrimaModel(
        id: id,
        fabricanteModel: fabricanteModel!,
        produto: produtoModel!,
        corridaLote: corridaLote.text,
        anexos: anexos,
        status: status,
      );
}
