import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/extensions/text_controller_ext.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class ProdutoUtils {
  final TextController search = TextController();
}

class ProdutoCreateModel {
  final String id;
  TextController nome = TextController();
  TextController descricao = TextController();
  TextController massaFinal = TextController.number();
  FabricanteModel? fabricante;
  late bool isEdit;

  ProdutoCreateModel()
      : id = HashService.get,
        isEdit = false;

  ProdutoCreateModel.edit(ProdutoModel produto)
      : id = produto.id,
        isEdit = true {
    nome.text = produto.nome;
    descricao.text = produto.descricao;
    massaFinal = TextController.number(value: produto.massaFinal);
  }

  ProdutoModel toProdutoModel() => ProdutoModel(
      id: id,
      nome: nome.text,
      descricao: descricao.text,
      massaFinal: massaFinal.doubleValue);
}
