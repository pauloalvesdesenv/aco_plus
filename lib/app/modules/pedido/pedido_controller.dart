import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_prioridade_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_prioridade_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/dialogs/confirm_dialog.dart';
import 'package:aco_plus/app/core/dialogs/loading_dialog.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/automatizacao/automatizacao_controller.dart';
import 'package:aco_plus/app/modules/kanban/kanban_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_status_bottom.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedido_step_bottom.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_prioridade_view_model.dart';
import 'package:aco_plus/app/modules/pedido/view_models/pedido_view_model.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final pedidoCtrl = PedidoController();
PedidoModel get pedido => pedidoCtrl.pedido;

class PedidoController {
  static final PedidoController _instance = PedidoController._();

  PedidoController._();

  factory PedidoController() => _instance;

  final AppStream<PedidoUtils> utilsStream = AppStream<PedidoUtils>.seed(
    PedidoUtils(),
  );
  PedidoUtils get utils => utilsStream.value;

  final AppStream<PedidoArquivedUtils> utilsArquivedsStream =
      AppStream<PedidoArquivedUtils>.seed(PedidoArquivedUtils());
  PedidoArquivedUtils get utilsArquiveds => utilsArquivedsStream.value;

  void onInit() {
    utilsStream.add(PedidoUtils());
    FirestoreClient.pedidos.fetch();
  }

  final AppStream<PedidoCreateModel> formStream =
      AppStream<PedidoCreateModel>();
  PedidoCreateModel get form => formStream.value;

  void onInitCreatePage(PedidoModel? pedido) {
    formStream.add(
      pedido != null ? PedidoCreateModel.edit(pedido) : PedidoCreateModel(),
    );
  }

  List<PedidoModel> getPedidosFiltered(
    String search,
    List<PedidoModel> pedidos,
  ) {
    pedidos =
        utils.steps.isEmpty
            ? pedidos
            : pedidos.where((e) => e.step.id == utils.steps.last.id).toList();
    if (search.length < 3) return pedidos;
    List<PedidoModel> filtered = [];
    for (final pedido in pedidos) {
      if (pedido.filtro.toCompare.contains(search.toCompare)) {
        filtered.add(pedido);
      }
    }
    return filtered;
  }

  List<PedidoModel> getPedidosArchivedsFiltered(
    String search,
    List<PedidoModel> pedidos,
  ) {
    pedidos =
        utilsArquiveds.steps.isEmpty
            ? pedidos
            : pedidos
                .where(
                  (e) =>
                      utilsArquiveds.steps.map((e) => e.id).contains(e.step.id),
                )
                .toList();
    if (search.length < 3) return pedidos;
    List<PedidoModel> filtered = [];
    for (final pedido in pedidos) {
      if (pedido.filtro.toCompare.contains(search.toCompare)) {
        filtered.add(pedido);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, PedidoModel? pedido, bool isFromOrder) async {
    try {
      onValid();
      if (form.produto.produtoModel != null &&
          form.produto.qtde.text.isNotEmpty) {
        if (!await showConfirmDialog(
          'Produto não confirmado',
          'Você adicionou a quantidade mas não confirmou o produto. Deseja continuar?',
        )) {
          return;
        }
      }
      if (form.isEdit) {
        final edit = form.toPedidoModel(pedido);
        final update = await FirestoreClient.pedidos.update(edit);
        if (update != null) {
          pedidoStream.add(update);
          pedidoStream.update();
        }
      } else {
        PedidoModel pedidoModel = form.toPedidoModel(pedido);
        await FirestoreClient.pedidos.add(pedidoModel);
        await FirestoreClient.pedidos.fetch();
      }
      if (isFromOrder) {
        Navigator.pop(value, form.isEdit ? pedido : null);
      } else {
        pop(value);
      }
      NotificationService.showPositive(
        'Pedido ${form.isEdit ? 'Editado' : 'Adicionado'}',
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

  Future<bool> onDelete(
    value,
    PedidoModel pedido, {
    bool isPedido = true,
  }) async {
    if (await _isDeleteUnavailable(pedido)) return false;
    await FirestoreClient.pedidos.delete(pedido);
    if (isPedido) {
      pop(value);
    }
    NotificationService.showPositive(
      'Pedido Excluida',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
    return true;
  }

  Future<bool> _isDeleteUnavailable(PedidoModel pedido) async =>
      !await onDeleteProcess(
        deleteTitle: 'Deseja excluir o pedido?',
        deleteMessage: 'Todos seus dados do pedido apagados do sistema',
        infoMessage:
            'Não é possível exlcuir o pedido, pois ele está vinculado a uma ordem de produção.',
        conditional: FirestoreClient.ordens.data
            .expand((e) => e.produtos.map((e) => e.pedidoId))
            .any((e) => e == pedido.id),
      );

  void onValid() {
    if (form.cliente == null) {
      throw Exception('Localizador não pode ser vazio');
    }
    if (form.cliente == null) {
      throw Exception('Selecione o cliente do pedido');
    }
    if (form.tipo == null) {
      throw Exception('Selecione o tipo do pedido');
    }
    if (form.obra == null) {
      throw Exception('Selecione a obra do pedido');
    }
    if (form.step == null) {
      throw Exception('Selecione a etapa inicial do pedido');
    }
  }

  //PEDIDO
  AppStream<PedidoModel> pedidoStream = AppStream<PedidoModel>();
  PedidoModel get pedido => pedidoStream.value;

  void setPedido(PedidoModel? pedido) {
    if (pedido != null) {
      pedidoStream.add(pedido);
    } else {
      pedidoStream = AppStream<PedidoModel>();
    }
  }

  OrdemModel? getOrdemByProduto(PedidoProdutoModel produto) {
    return FirestoreClient.ordens.data.firstWhereOrNull(
      (e) => e.produtos.any((p) => p.id == produto.id),
    );
  }

  void onInitPage(PedidoModel pedido) {
    pedidoStream.add(pedido);
  }

  void onChangePedidoStatus(PedidoModel pedido) async {
    final status = await showPedidoStatusBottom(pedido);
    if (status == null) return;
    if (pedido.statusess.last.status == status) return;
    pedido.statusess.add(PedidoStatusModel.create(status));
    await automatizacaoCtrl.onSetStepByPedidoStatus([pedido]);
    pedidoStream.update();
    await FirestoreClient.pedidos.update(pedido);
  }

  void onChangePedidoStep(PedidoModel pedido) async {
    final step = await showPedidoStepBottom(pedido);
    if (step == null) return;
    if (pedido.steps.last.step.id == step.id) return;
    kanbanCtrl.onAccept(step, pedido, 0);
    pedidoStream.update();
  }

  void onSortPedidos(List<PedidoModel> pedidos) {
    bool isAsc = utils.sortOrder == SortOrder.asc;
    switch (utils.sortType) {
      case SortType.localizator:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? a.localizador.compareTo(b.localizador)
                  : b.localizador.compareTo(a.localizador),
        );
        break;
      case SortType.alfabetic:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? a.localizador.compareTo(b.localizador)
                  : b.localizador.compareTo(a.localizador),
        );
        break;
      case SortType.deliveryAt:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? (a.deliveryAt ?? DateTime.now()).compareTo(
                    (b.deliveryAt ?? DateTime.now()),
                  )
                  : (b.deliveryAt ?? DateTime.now()).compareTo(
                    (a.deliveryAt ?? DateTime.now()),
                  ),
        );
        break;
      case SortType.createdAt:
        pedidos.sort(
          (a, b) =>
              isAsc
                  ? a.createdAt.compareTo(b.createdAt)
                  : b.createdAt.compareTo(a.createdAt),
        );
        break;
      default:
    }
  }

  void updatePedidoFirestore() {
    pedidoStream.update();
    FirestoreClient.pedidos.update(pedido);
  }

  void onAddHistory({
    required PedidoModel pedido,
    required dynamic data,
    required PedidoHistoryAction action,
    required PedidoHistoryType type,
    bool isFromAutomatizacao = false,
  }) {
    pedido.histories.add(
      PedidoHistoryModel.create(
        data: data,
        action: action,
        type: type,
        isFromAutomatizacao: isFromAutomatizacao,
      ),
    );
    FirestoreClient.pedidos.update(pedido);
  }

  void setPedidoUsuarios(PedidoModel pedido, List<UsuarioModel> usuarios) {
    pedido.users.clear();
    pedido.users.addAll(usuarios);
    pedidoStream.add(pedido);
    FirestoreClient.pedidos.update(pedido);
  }

  Future<bool> onArchive(
    value,
    PedidoModel pedido, {
    bool isPedido = true,
  }) async {
    if (pedido.produtos.any(
      (e) => e.status.status != PedidoProdutoStatus.pronto,
    )) {
      NotificationService.showNegative(
        'Pedido não pode ser arquivado',
        'O pedido possui ordens não concluídas',
      );
      return false;
    }
    if (!await showConfirmDialog(
      'Deseja arquivar esse pedidos?',
      'O pedido ficará disponível na lista de arquivados',
    )) {
      return false;
    }
    showLoadingDialog();
    pedido.isArchived = !pedido.isArchived;
    await FirestoreClient.pedidos.update(pedido);
    await FirestoreClient.pedidos.fetch();
    Navigator.pop(contextGlobal);
    if (isPedido) Navigator.pop(value);
    NotificationService.showPositive(
      'Pedido Arquivado!',
      'Acesse a lista de arquivados para visualizar o pedido',
      position: NotificationPosition.bottom,
    );
    return true;
  }

  Future<void> onUnArchivePedido(value, PedidoModel pedido, int pops) async {
    if (await showConfirmDialog(
      'Deseja desarquivar o pedido?',
      'O pedido voltará para a lista de pedidos',
    )) {
      pedido.isArchived = false;
      showLoadingDialog();
      await FirestoreClient.pedidos.update(pedido);
      await FirestoreClient.pedidos.fetch();
      Navigator.pop(contextGlobal);
      for (var i = 0; i < pops; i++) {
        Navigator.pop(value);
      }
      NotificationService.showPositive(
        'Pedido Desarquivado!',
        'Acesse a lista de pedidos para visualizar o pedido',
      );
    }
  }

  List<PedidoHistoryModel> getHistoricoAcompanhamento(PedidoModel pedido) {
    List<PedidoHistoryModel> histories =
        pedido.histories.reversed
            .where((e) => e.type == PedidoHistoryType.step)
            .toList();

    histories =
        histories.where((e) {
          final data = e.data as StepModel?;
          return data?.isShipping ?? false;
        }).toList();

    return histories;
  }

  int getIndexStep(PedidoHistoryModel history) {
    final stepHistory = history.data as StepModel;
    final step = FirestoreClient.steps.getById(stepHistory.id);
    return step.index;
  }

  Future<void> onGeneratePDF(PedidoModel pedido) async {
    final RelatorioPedidoViewModel relatorio = RelatorioPedidoViewModel();
    relatorio.cliente = FirestoreClient.clientes.getById(pedido.cliente.id);
    relatorio.produtos =
        pedido.produtos.map((e) => e.copyWith()).map((e) => e.produto).toList();
    relatorio.status =
        pedido.produtos
            .map((e) => e.copyWith())
            .map((e) => e.status.status)
            .toSet()
            .toList();

    relatorio.tipo = RelatorioPedidoTipo.pedidos;

    final model = RelatorioPedidoModel(
      relatorio.cliente,
      relatorio.status,
      [pedido],
      relatorio.tipo,
      relatorio.produtos,
    );

    relatorio.relatorio = model;

    relatorioCtrl.pedidoViewModelStream.add(relatorio);

    // relatorioCtrl.onCreateRelatorio();

    await relatorioCtrl.onExportRelatorioPedidoPDF(
      relatorio,
      name: pedido.localizador,
    );
  }

  //PEDIDO PRIORIDADE
  final AppStream<PedidoPrioridadeCreateModel> formPrioridadeStream =
      AppStream<PedidoPrioridadeCreateModel>();
  PedidoPrioridadeCreateModel get formPrioridade => formPrioridadeStream.value;

  void onInitPrioridade(PedidoModel pedido) {
    final pedidos = _getPedidosByPrioridadeTipo(
      pedido,
      pedido.prioridade?.tipo ?? PedidoPrioridadeTipo.cd,
    );

    formPrioridadeStream.add(PedidoPrioridadeCreateModel(pedidos: pedidos));
  }

  List<PedidoModel> _getPedidosByPrioridadeTipo(
    PedidoModel pedido,
    PedidoPrioridadeTipo tipo,
  ) {
    final pedidos =
        FirestoreClient.pedidos.pedidosPrioridade
            .where((e) => e.prioridade?.tipo == tipo)
            .map((e) => e.copyWith())
            .toList();
    if (pedido.prioridade?.tipo != tipo) {
      final copy = pedido.copyWith(
        prioridade: PedidoPrioridadeModel(
          index: 0,
          tipo: tipo,
          createdAt: DateTime.now(),
        ),
      );
      pedidos.insert(0, copy);
      for (var i = 1; i < pedidos.length; i++) {
        final copy = pedidos[i].copyWith(
          prioridade: pedidos[i].prioridade!.copyWith(index: i),
        );
        pedidos[i] = copy;
      }
    }
    pedidos.sort((a, b) => a.prioridade!.index.compareTo(b.prioridade!.index));
    return pedidos;
  }

  Future<void> onConfirmarPrioridade(context, PedidoModel pedido) async {
    showLoadingDialog();
    await FirestoreClient.pedidos.updateAll(formPrioridade.pedidos);
    final pedidoInList = formPrioridade.pedidos.firstWhere(
      (e) => e.id == pedido.id,
    );
    if (pedido.prioridade?.tipo != pedidoInList.prioridade?.tipo) {
      final pedidos =
          FirestoreClient.pedidos.pedidosPrioridade
              .where((e) => e.prioridade?.tipo == pedido.prioridade?.tipo)
              .toList();
      for (var i = 0; i < pedidos.length; i++) {
        final copy = pedidos[i].copyWith(
          prioridade: pedidos[i].prioridade!.copyWith(index: i),
        );
        pedidos[i] = copy;
      }
      await FirestoreClient.pedidos.updateAll(pedidos);
    }
    Navigator.pop(contextGlobal);
    Navigator.pop(
      context,
      formPrioridade.pedidos.firstWhere((e) => e.id == pedido.id),
    );
    NotificationService.showPositive(
      'Pedido Prioridade',
      'Pedido prioridade atualizado com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  void onReorderPrioridade(List<PedidoModel> pedidos) {
    for (var i = 0; i < pedidos.length; i++) {
      final copy = pedidos[i].copyWith(
        prioridade: pedidos[i].prioridade!.copyWith(index: i),
      );
      pedidos[i] = copy;
    }
    pedidos.sort((a, b) => a.prioridade!.index.compareTo(b.prioridade!.index));
  }

  void onSelectPrioridadeTipo(PedidoModel pedido, PedidoPrioridadeTipo e) {
    final pedidos = _getPedidosByPrioridadeTipo(pedido, e);
    formPrioridadeStream.add(PedidoPrioridadeCreateModel(pedidos: pedidos));
  }

  Future<void> onRemoverPrioridade(
    BuildContext context,
    PedidoModel pedido,
  ) async {
    pedido.prioridade = null;
    showLoadingDialog();
    await FirestoreClient.pedidos.update(pedido);
    onReorderPrioridade(FirestoreClient.pedidos.pedidosPrioridade);
    await FirestoreClient.pedidos.updateAll(
      FirestoreClient.pedidos.pedidosPrioridade,
    );
    // await FirestoreClient.pedidos.fetch();
    Navigator.pop(contextGlobal);
    Navigator.pop(context, pedido);
    NotificationService.showPositive(
      'Pedido Prioridade',
      'Pedido prioridade removida com sucesso',
      position: NotificationPosition.bottom,
    );
  }
}
