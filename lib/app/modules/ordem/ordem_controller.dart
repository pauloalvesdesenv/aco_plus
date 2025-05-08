import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/dialogs/loading_dialog.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/services/pdf_download_service/pdf_download_service_mobile.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/automatizacao/automatizacao_controller.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_etiquetas_pdf_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_produto_status_bottom.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordem_produtos_status_bottom.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pdf/widgets.dart' as pw;

final ordemCtrl = OrdemController();

class OrdemController {
  static final OrdemController _instance = OrdemController._();

  OrdemController._();

  factory OrdemController() => _instance;

  final AppStream<OrdemUtils> utilsStream = AppStream<OrdemUtils>.seed(
    OrdemUtils(),
  );
  OrdemUtils get utils => utilsStream.value;

  final AppStream<OrdemArquivadasUtils> utilsArquivadasStream =
      AppStream<OrdemArquivadasUtils>.seed(OrdemArquivadasUtils());
  OrdemArquivadasUtils get utilsArquivadas => utilsArquivadasStream.value;

  void onInit() {
    utilsStream.add(OrdemUtils());
    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);
  }

  List<OrdemModel> getOrdensFiltered(String search, List<OrdemModel> ordens) {
    if (search.length < 3) return ordens;
    List<OrdemModel> filtered = [];
    for (final ordem in ordens) {
      if (ordem.localizator.toString().toCompare.contains(search.toCompare)) {
        filtered.add(ordem);
      }
    }
    return filtered;
  }

  final AppStream<OrdemCreateModel> formStream = AppStream<OrdemCreateModel>();
  OrdemCreateModel get form => formStream.value;

  void onInitCreatePage(OrdemModel? ordem) {
    formStream.add(
      ordem != null ? OrdemCreateModel.edit(ordem) : OrdemCreateModel(),
    );
  }

  List<PedidoProdutoModel> getPedidosPorProduto(
    ProdutoModel produto, {
    OrdemModel? ordem,
  }) {
    List<PedidoProdutoModel> pedidos = [
      ..._getPedidosProdutosAtual(ordem: ordem),
      ..._getPedidosProdutosSeparados(produto),
    ];
    onSortPedidos(pedidos);
    return pedidos;
  }

  List<PedidoProdutoModel> _getPedidosProdutosAtual({OrdemModel? ordem}) =>
      ordem != null
          ? ordem.produtos
              .map(
                (e) => e.copyWith(
                  isSelected: true,
                  isAvailable: e.isAvailableToChanges,
                ),
              )
              .toList()
          : [];

  List<PedidoProdutoModel> _getPedidosProdutosSeparados(ProdutoModel produto) {
    List<PedidoProdutoModel> pedidos = [];
    for (final pedido
        in FirestoreClient.pedidos.data
            .where(
              (e) => FirestoreClient.steps.getById(e.step.id).isPermiteProducao,
            )
            .toList()) {
      final pedidoProdutos =
          pedido.produtos
              .where(
                (e) =>
                    e.status.status == PedidoProdutoStatus.separado &&
                    e.produto.id == produto.id,
              )
              .toList();
      for (final pedidoProduto in pedidoProdutos) {
        final isFiltered =
            form.localizador.text.isEmpty ||
            pedidoProduto.pedido.localizador.toCompare.contains(
              form.localizador.text.toCompare,
            );
        if (isFiltered) {
          pedidos.add(pedidoProduto);
        }
      }
    }
    return pedidos;
  }

  List<PedidoProdutoModel> getPedidosPorProdutoEdit(OrdemModel ordem) {
    final pedidos =
        ordem.produtos
            .where(
              (e) =>
                  form.localizador.text.isEmpty ||
                  e.cliente.nome.toCompare.contains(
                    form.localizador.text.toCompare,
                  ),
            )
            .toList();
    onSortPedidos(pedidos);

    return pedidos;
  }

  Future<void> onConfirm(value, OrdemModel? ordem) async {
    try {
      if (form.isEdit) {
        await onEdit(value, ordem!);
      } else {
        await onCreate(value);
      }
    } catch (value) {
      NotificationService.showNegative(
        'Erro',
        value.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onCreate(value) async {
    form.id =
        'OP${form.produto!.descricao.replaceAll('m', '').replaceAll('.', '')}${form.id}';

    final ordemCriada = form.toOrdemModel();
    onValid(ordemCriada);
    if (ordemCriada.produtos.isEmpty) {
      if (!await showConfirmDialog(
        'Você está criando uma ordem vazia.',
        'Deseja Continuar?',
      )) {
        return;
      }
    }
    for (PedidoProdutoModel produto in ordemCriada.produtos) {
      await FirestoreClient.pedidos.updateProdutoStatus(
        produto,
        produto.statusess.last.status,
      );
    }
    await FirestoreClient.ordens.add(ordemCriada);
    await FirestoreClient.pedidos.fetch();
    await automatizacaoCtrl.onSetStepByPedidoStatus(
      ordemCriada.pedidos
          .map((e) => FirestoreClient.pedidos.getById(e.id))
          .toList(),
    );
    Navigator.pop(value);
    NotificationService.showPositive(
      'Ordem Adicionada',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<void> onEdit(value, OrdemModel ordem) async {
    await FirestoreClient.pedidos.fetch();
    final ordemEditada = form.toOrdemModel();
    onValid(ordemEditada);
    if (ordemEditada.produtos.isEmpty) {
      if (!await showConfirmDialog('A ordem vazia.', 'Deseja Continuar?')) {
        return;
      }
    }
    for (PedidoProdutoModel produto in ordem.produtos) {
      if (!ordemEditada.produtos.contains(produto)) {
        await FirestoreClient.pedidos.updateProdutoStatus(
          produto,
          PedidoProdutoStatus.separado,
          clear: true,
        );
      }
    }
    for (PedidoProdutoModel produto in ordemEditada.produtos) {
      await FirestoreClient.pedidos.updateProdutoStatus(
        produto,
        produto.statusess.last.status,
      );
    }
    //TODO
    ordemEditada.produtos.removeWhere((e) => e.status.status.index == 0);
    await FirestoreClient.ordens.update(ordemEditada);
    await FirestoreClient.pedidos.fetch();
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordemEditada.pedidos);
    Navigator.pop(value);
    Navigator.pop(value);
    NotificationService.showPositive(
      'Ordem Editada',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  void onValid(OrdemModel ordem) {
    if (form.produto == null) {
      throw Exception('Selecione o produto');
    }
  }

  Future<void> onDelete(value, OrdemModel ordem) async {
    if (await _isDeleteUnavailable(ordem)) return;
    for (var pedidoProduto
        in ordem.produtos
            .map(
              (e) => FirestoreClient.pedidos.getProdutoByPedidoId(
                e.pedidoId,
                e.id,
              ),
            )
            .toList()) {
      pedidoProduto.statusess.clear();
      pedidoProduto.statusess.add(
        PedidoProdutoStatusModel(
          id: HashService.get,
          status: PedidoProdutoStatus.separado,
          createdAt: DateTime.now(),
        ),
      );
      await FirestoreClient.pedidos.update(
        FirestoreClient.pedidos.getById(pedidoProduto.pedidoId),
      );
    }
    ordem.produtos.clear();
    await FirestoreClient.ordens.delete(ordem);
    await automatizacaoCtrl.onSetStepByPedidoStatus(ordem.pedidos);
    pop(value);

    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);

    NotificationService.showPositive(
      'Ordem Excluida',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<bool> _isDeleteUnavailable(OrdemModel ordem) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir a ordem?',
        deleteMessage: 'Todos seus dados da ordem apagados do sistema',
        infoMessage: 'Remova os produtos da ordem para poder excluir-la.',
        conditional: ordem.produtos.isNotEmpty,
      );

  void onSortPedidos(List<PedidoProdutoModel> pedidos) {
    bool isAsc = form.sortOrder == SortOrder.asc;
    switch (form.sortType) {
      case SortType.localizator:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? a.pedido.localizador.compareTo(b.pedido.localizador)
                  : b.pedido.localizador.compareTo(a.pedido.localizador),
        );
        break;
      case SortType.alfabetic:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? a.pedido.localizador.compareTo(b.pedido.localizador)
                  : b.pedido.localizador.compareTo(a.pedido.localizador),
        );
        break;
      case SortType.createdAt:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? (a.pedido.deliveryAt ?? DateTime.now()).compareTo(
                    (b.pedido.deliveryAt ?? DateTime.now()),
                  )
                  : (b.pedido.deliveryAt ?? DateTime.now()).compareTo(
                    (a.pedido.deliveryAt ?? DateTime.now()),
                  ),
        );
        break;
      default:
    }
  }

  //ORDEM
  final AppStream<OrdemModel> ordemStream = AppStream<OrdemModel>();
  OrdemModel get ordem => ordemStream.value;

  void onInitPage(String ordemId) {
    ordemStream.add(getOrdemById(ordemId));
  }

  OrdemModel getOrdemById(String ordemId) {
    final ordem = FirestoreClient.ordens.getById(ordemId);
    return ordem;
  }

  void setOrdem(OrdemModel ordem) {
    ordemStream.add(ordem);
  }

  void showBottomChangeProdutosStatus(List<PedidoProdutoModel> produtos) async {
    final status = await showOrdemProdutosStatusBottom();
    if (status == null) return;
    if (!await showConfirmDialog(
      'Mover alterar status de todos os produtos?',
      'Todos os produtos serão alterados para ${status.label}.\nEsta ação pode demorar um pouco.',
    )) {
      return;
    }
    showLoadingDialog();
    for (final produto
        in produtos.where((e) => e.status.status != status).toList()) {
      await onChangeProdutoStatus(produto, status);
    }
    Navigator.pop(contextGlobal);
    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);
    onUpdateAt(ordem);
  }

  void showBottomChangeProdutoStatus(
    OrdemModel ordem,
    PedidoProdutoModel produto,
  ) async {
    final produtoStatus = produto.statusess.last.status;
    final status = await showOrdemProdutoStatusBottom(produtoStatus);
    if (status == null || produtoStatus == status) return;
    await onChangeProdutoStatus(produto, status);
    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);
    onUpdateAt(ordem);
  }

  Future<void> onSelectProdutoStatus(
    OrdemModel ordem,
    PedidoProdutoModel produto,
    PedidoProdutoStatus status,
  ) async {
    await onChangeProdutoStatus(produto, status);
    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);
    onUpdateAt(ordem);
  }

  Future<void> onChangeProdutoStatus(
    PedidoProdutoModel produto,
    PedidoProdutoStatus status,
  ) async {
    await FirestoreClient.pedidos.updateProdutoStatus(produto, status);
    final pedido = await FirestoreClient.pedidos.updatePedidoStatus(produto);
    if (pedido != null) await updateFeaturesByPedidoStatus(pedido);
    await FirestoreClient.ordens.fetch();
    setOrdem(getOrdemById(ordem.id));
  }

  Future<void> updateFeaturesByPedidoStatus(PedidoModel pedido) async {
    await automatizacaoCtrl.onSetStepByPedidoStatus([pedido]);
    pedidoCtrl.onAddHistory(
      pedido: pedido,
      data: pedido.statusess.last,
      action: PedidoHistoryAction.update,
      type: PedidoHistoryType.status,
    );
  }

  Future<void> onFreezed(value, OrdemModel ordem) async {
    if (ordem.freezed.isFreezed) {
      if (!await showConfirmDialog(
        'Deseja descongelar a ordem?',
        'A ordem voltará na ultima posição da esteira de produção.',
      )) {
        return;
      }
      ordem.freezed.isFreezed = false;
      ordem.freezed.reason.controller.clear();
    } else {
      if (!await showConfirmDialog(
        'Deseja congelar a ordem?',
        'A ordem irá sair da esteira de produção.',
      )) {
        return;
      }
      ordem.freezed.isFreezed = true;
    }
    await FirestoreClient.ordens.update(ordem);
    onReorder(FirestoreClient.ordens.ordensNaoCongeladas);
    Navigator.pop(value);
    if (ordem.freezed.isFreezed) {
      NotificationService.showPositive(
        'Ordem ${ordem.localizator} congelada!',
        'Ordem foi removida da esteira de produção',
      );
    } else {
      NotificationService.showPositive(
        'Ordem ${ordem.localizator} descongelada!',
        'Ordem foi adicionada na ultima posição esteira de produção',
      );
    }
  }

  void onReorder(List<OrdemModel> ordensNaoConcluidas) {
    for (var i = 0; i < ordensNaoConcluidas.length; i++) {
      ordensNaoConcluidas[i].beltIndex = i;
      FirestoreClient.ordens.dataStream.update();
      FirestoreClient.ordens.update(ordensNaoConcluidas[i]);
    }
  }

  Future<void> onGenerateRelatorioPDF(OrdemModel ordem) async {
    final RelatorioOrdemViewModel relatorio = RelatorioOrdemViewModel();
    relatorio.ordem = ordem;
    relatorio.type = RelatorioOrdemType.ORDEM;
    relatorio.relatorio = RelatorioOrdemModel.ordem(ordem);

    relatorioCtrl.ordemViewModelStream.add(relatorio);

    await relatorioCtrl.onExportRelatorioOrdemUniquePDF(
      RelatorioOrdemModel.ordem(ordem),
    );
  }

  Future<void> onGenerateEtiquetasPDF(OrdemModel ordem) async {
    List<OrdemEtiquetaModel> model = [];
    for (var produto in ordem.produtos) {
      model.add(
        OrdemEtiquetaModel(
          cliente: produto.pedido.cliente,
          obra: produto.pedido.obra,
          pedido: produto.pedido,
          ordem: ordem.copyWith(produtos: [produto.copyWith()]),
          createdAt: DateTime.now(),
          produto: produto,
        ),
      );
    }

    final pdf = pw.Document();

    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();

    pdf.addPage(OrdemEtiquetasPdfPage(model).build(imageBytes));

    final name =
        "m2_etiquetas_ordem_${ordem.localizator.toLowerCase()}_${DateTime.now().toFileName()}.pdf";

    await downloadPDF(name, '/ordem/etiquetas/', await pdf.save());
  }

  Future<void> onArchive(BuildContext context, OrdemModel ordem) async {
    ordem.isArchived = true;
    showLoadingDialog();
    await FirestoreClient.ordens.update(ordem);
    await FirestoreClient.ordens.fetch();
    Navigator.pop(contextGlobal);
    Navigator.pop(context);
    NotificationService.showPositive(
      'Ordem Arquivada!',
      'Acesse a lista de ordens arquivadas para visualizar a ordem',
    );
  }

  Future<void> onUnarchive(
    BuildContext context,
    OrdemModel ordem,
    int pop,
  ) async {
    ordem.isArchived = false;
    showLoadingDialog();
    await FirestoreClient.ordens.update(ordem);
    await FirestoreClient.ordens.fetch();
    Navigator.pop(contextGlobal);
    for (var i = 0; i < pop; i++) {
      Navigator.pop(context);
    }
    NotificationService.showPositive(
      'Ordem Desarquivada!',
      'Acesse a lista de ordens para visualizar a ordem',
    );
  }

  Future<void> onUpdateAt(OrdemModel ordem) async {
    ordem.updatedAt = DateTime.now();
    await FirestoreClient.ordens.update(ordem);
  }
}
