import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final materiaPrimaCtrl = MateriaPrimaController();
MateriaPrimaModel get materiaPrima => materiaPrimaCtrl.materiaPrima!;

class MateriaPrimaController {
  static final MateriaPrimaController _instance = MateriaPrimaController._();

  MateriaPrimaController._();

  factory MateriaPrimaController() => _instance;

  final AppStream<MateriaPrimaModel?> materiaPrimaStream =
      AppStream<MateriaPrimaModel?>.seed(null);
  MateriaPrimaModel? get materiaPrima => materiaPrimaStream.value;

  final AppStream<MateriaPrimaUtils> utilsStream =
      AppStream<MateriaPrimaUtils>.seed(MateriaPrimaUtils());
  MateriaPrimaUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(MateriaPrimaUtils());
    FirestoreClient.materiaPrimas.fetch();
  }

  final AppStream<MateriaPrimaCreateModel> formStream =
      AppStream<MateriaPrimaCreateModel>();
  MateriaPrimaCreateModel get form => formStream.value;

  void init(MateriaPrimaModel? materiaPrima) {
    formStream.add(materiaPrima != null
        ? MateriaPrimaCreateModel.edit(materiaPrima)
        : MateriaPrimaCreateModel());
  }

  List<MateriaPrimaModel> getMateriaPrimaesFiltered(
      String search, List<MateriaPrimaModel> materiaPrimas) {
    if (search.length < 3) return materiaPrimas;
    List<MateriaPrimaModel> filtered = [];
    for (final materiaPrima in materiaPrimas) {
      if (materiaPrima.toString().toCompare.contains(search.toCompare)) {
        filtered.add(materiaPrima);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(_, MateriaPrimaModel? materiaPrima) async {
    try {
      onValid(materiaPrima);
      if (form.isEdit) {
        final edit = form.toMateriaPrimaModel();
        await FirestoreClient.materiaPrimas.update(edit);
      } else {
        await FirestoreClient.materiaPrimas.add(form.toMateriaPrimaModel());
      }
      pop(_);
      NotificationService.showPositive(
          'Matéria Prima ${form.isEdit ? 'Editada' : 'Adicionada'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  Future<void> onDelete(_, MateriaPrimaModel materiaPrima) async {
    if (await _isDeleteUnavailable(materiaPrima)) return;
    await FirestoreClient.materiaPrimas.delete(materiaPrima);
    pop(_);
    NotificationService.showPositive(
        'Matéria Prima Excluída', 'Operação realizada com sucesso',
        position: NotificationPosition.bottom);
  }

  Future<bool> _isDeleteUnavailable(MateriaPrimaModel materiaPrima) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir a Matéria Prima?',
        deleteMessage: 'Todos seus dados serão apagados do sistema',
        infoMessage:
            'Não é possível exlcuir a Matéria Prima, pois ela está vinculada a uma Ordem.',
        conditional: true,
        // conditional: FirestoreClient.produtos.data
        //     .any((e) => e.materiaPrima.id == materiaPrima.id),
      );

  void onValid(MateriaPrimaModel? materiaPrima) {
    if (form.fabricanteModel == null) {
      throw Exception('Fabricante é obrigatório');
    }
    if (form.produtoModel == null) {
      throw Exception('Produto é obrigatório');
    }
    if (form.corridaLote.text.length < 2) {
      throw Exception('Corrida deve conter no mínimo 3 caracteres');
    }
  }

  List<ProdutoModel> getProdutosAvailable(FabricanteModel? fabricante) {
    if (fabricante == null) return [];
    final produtos = FirestoreClient.produtos.data;
    final materiaPrimas = FirestoreClient.materiaPrimas.data.where((e) =>
        e.status == MateriaPrimaStatus.disponivel &&
        e.fabricanteModel.id == fabricante.id);
    return produtos
        .where((e) => !materiaPrimas.any((m) => m.produto.id == e.id))
        .toList();
  }
}
