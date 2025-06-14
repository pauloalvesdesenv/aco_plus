import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/materia_prima/materia_prima_view_model.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
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
    formStream.add(
      materiaPrima != null
          ? MateriaPrimaCreateModel.edit(materiaPrima)
          : MateriaPrimaCreateModel(),
    );
  }

  List<MateriaPrimaModel> getMateriaPrimaesFiltered(
    String search,
    List<MateriaPrimaModel> materiaPrimas,
  ) {
    if (search.length < 3) return materiaPrimas;
    List<MateriaPrimaModel> filtered = [];
    for (final materiaPrima in materiaPrimas) {
      if (materiaPrima.toString().toCompare.contains(search.toCompare)) {
        filtered.add(materiaPrima);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, MateriaPrimaModel? materiaPrima) async {
    try {
      onValid(materiaPrima);
      if (usuario.isOperador) {
        form.corridaLote.text =
            '${form.fabricanteModel!.nome} - ${form.produtoModel!.nome}';
      }
      if (form.isEdit) {
        final edit = form.toMateriaPrimaModel();
        if (edit.status == MateriaPrimaStatus.finalizada) {
          await finalizarMateriaPrima(edit);
        }
        await FirestoreClient.materiaPrimas.update(edit);
      } else {
        await FirestoreClient.materiaPrimas.add(form.toMateriaPrimaModel());
      }
      pop(value);
      NotificationService.showPositive(
        'Matéria Prima ${form.isEdit ? 'Editada' : 'Adicionada'}',
        'Operação realizada com sucesso',
        position: NotificationPosition.bottom,
      );
    } catch (e) {
      NotificationService.showNegative(
        'Erro',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onDelete(value, MateriaPrimaModel materiaPrima) async {
    if (await _isDeleteUnavailable(materiaPrima)) return;
    await FirestoreClient.materiaPrimas.delete(materiaPrima);
    pop(value);
    NotificationService.showPositive(
      'Matéria Prima Excluída',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<bool> _isDeleteUnavailable(
    MateriaPrimaModel materiaPrima,
  ) async => !await onDeleteProcess(
    deleteTitle: 'Deseja excluir a Matéria Prima?',
    deleteMessage: 'Todos seus dados serão apagados do sistema',
    infoMessage:
        'Não é possível exlcuir a Matéria Prima, pois ela está sendo utilizada.',
    conditional: FirestoreClient.produtos.data.any(
      (e) => e.id == materiaPrima.id,
    ),
  );

  void onValid(MateriaPrimaModel? materiaPrima) {
    if (form.fabricanteModel == null) {
      throw Exception('Fabricante é obrigatório');
    }
    if (form.produtoModel == null) {
      throw Exception('Produto é obrigatório');
    }
    if (usuario.isNotOperador) {
      if (form.corridaLote.text.length < 2) {
        throw Exception('Corrida deve conter no mínimo 3 caracteres');
      }
    }
  }

  List<ProdutoModel> getProdutosAvailable(FabricanteModel? fabricante) {
    if (fabricante == null) return [];
    final produtos = FirestoreClient.produtos.data;
    final materiaPrimas = FirestoreClient.materiaPrimas.data.where(
      (e) =>
          e.status == MateriaPrimaStatus.disponivel &&
          e.fabricanteModel.id == fabricante.id,
    );
    return produtos
        .where((e) => !materiaPrimas.any((m) => m.produto.id == e.id))
        .toList();
  }

  bool hasChangeInMateriaPrima(MateriaPrimaModel materiaPrima) {
    return !(materiaPrima.fabricanteModel.id == form.fabricanteModel?.id &&
        materiaPrima.produto.id == form.produtoModel?.id &&
        materiaPrima.corridaLote == form.corridaLote.text &&
        materiaPrima.status == form.status &&
        materiaPrima.anexos.length == form.anexos.length);
  }

  Future<void> finalizarMateriaPrima(MateriaPrimaModel materiaPrima) async {
    try {
      final result = await showConfirmDialog(
        'Mover Matéria Prima para finalizada',
        'Deseja mover a Matéria Prima para finalizada?',
      );
      if (result == true) {
        for (final ordem in FirestoreClient.ordens.data.where(
          (e) =>
              e.status != PedidoProdutoStatus.pronto &&
              e.status != PedidoProdutoStatus.separado,
        )) {
          if (ordem.materiaPrima?.id == materiaPrima.id) {
            ordem.materiaPrima = null;
            await FirestoreClient.ordens.update(ordem);
          }
          for (final produto in ordem.produtos.where(
            (e) =>
                e.status.status != PedidoProdutoStatus.pronto &&
                e.status.status != PedidoProdutoStatus.separado,
          )) {
            if (produto.materiaPrima?.id == materiaPrima.id) {
              await FirestoreClient.pedidos.updateProdutoMateriaPrima(
                produto,
                null,
              );
            }
          }
        }
        materiaPrima.status = MateriaPrimaStatus.finalizada;
        await FirestoreClient.materiaPrimas.update(materiaPrima);
        await FirestoreClient.materiaPrimas.fetch();
        NotificationService.showPositive(
          'Matéria Prima finalizada',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom,
        );
      }
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString());
    }
  }
}
