import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/produto/produto_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final produtoCtrl = ProdutoController();
ProdutoModel get produto => produtoCtrl.produto!;

class ProdutoController {
  static final ProdutoController _instance = ProdutoController._();

  ProdutoController._();

  factory ProdutoController() => _instance;

  final AppStream<ProdutoModel?> produtoStream = AppStream<ProdutoModel?>.seed(
    null,
  );
  ProdutoModel? get produto => produtoStream.value;

  final AppStream<ProdutoUtils> utilsStream = AppStream<ProdutoUtils>.seed(
    ProdutoUtils(),
  );
  ProdutoUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(ProdutoUtils());
    FirestoreClient.produtos.fetch();
  }

  final AppStream<ProdutoCreateModel> formStream =
      AppStream<ProdutoCreateModel>();
  ProdutoCreateModel get form => formStream.value;

  void init(ProdutoModel? produto) {
    formStream.add(
      produto != null ? ProdutoCreateModel.edit(produto) : ProdutoCreateModel(),
    );
  }

  List<ProdutoModel> getProdutoesFiltered(
    String search,
    List<ProdutoModel> produtos,
  ) {
    if (search.length < 3) return produtos;
    List<ProdutoModel> filtered = [];
    for (final produto in produtos) {
      if (produto.toString().toCompare.contains(search.toCompare)) {
        filtered.add(produto);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, ProdutoModel? produto) async {
    try {
      onValid(produto);
      if (form.isEdit) {
        final edit = form.toProdutoModel();
        await FirestoreClient.produtos.update(edit);
      } else {
        await FirestoreClient.produtos.add(form.toProdutoModel());
      }
      pop(value);
      NotificationService.showPositive(
        'Produto ${form.isEdit ? 'Editado' : 'Adicionado'}',
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

  Future<void> onDelete(value, ProdutoModel produto) async {
    if (await _isDeleteUnavailable(produto)) return;
    await FirestoreClient.produtos.delete(produto);
    pop(value);
    NotificationService.showPositive(
      'Produto Excluido',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<bool> _isDeleteUnavailable(ProdutoModel produto) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir o produto?',
        deleteMessage: 'Todos seus dados serão apagados do sistema',
        infoMessage:
            'Não é possível excluir o produto, pois ele está vinculado a outras partes do sistema.',
        conditional: FirestoreClient.pedidos.data.any(
          (e) => e.produtos.any((p) => p.produto.id == produto.id),
        ),
      );

  void onValid(ProdutoModel? produto) {
    if (form.nome.text.length < 2) {
      throw Exception('Nome deve conter no mínimo 3 caracteres');
    }
    if (form.isEdit) {
      if (FirestoreClient.produtos.data.any((e) => e.nome == form.nome.text)) {
        throw Exception('Já existe um produto com esse nome');
      }
    }
  }
}
