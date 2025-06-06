import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:flutter/material.dart';

enum OrdemExportarPdfTipo { relatorio, etiquetas }

extension OrdemExportarPdfTipoExtension on OrdemExportarPdfTipo {
  String get label {
    switch (this) {
      case OrdemExportarPdfTipo.relatorio:
        return 'Relatório';
      case OrdemExportarPdfTipo.etiquetas:
        return 'Etiquetas';
    }
  }

  IconData get icon {
    switch (this) {
      case OrdemExportarPdfTipo.relatorio:
        return Icons.file_present;
      case OrdemExportarPdfTipo.etiquetas:
        return Icons.label_outline;
    }
  }
}

class OrdemUtils {
  bool showFilter = false;
  final TextController search = TextController();
  List<PedidoProdutoStatus> status = [
    PedidoProdutoStatus.aguardandoProducao,
    PedidoProdutoStatus.produzindo,
    PedidoProdutoStatus.pronto,
  ];
  ProdutoModel? produto;
}

class OrdemArquivadasUtils {
  bool showFilter = false;
  final TextController search = TextController();
  List<PedidoProdutoStatus> status = [
    PedidoProdutoStatus.aguardandoProducao,
    PedidoProdutoStatus.produzindo,
  ];
  ProdutoModel? produto;
}

class OrdemCreateModel {
  String id;
  ProdutoModel? produto;
  TextController localizador = TextController();
  List<PedidoProdutoModel> produtos = [];
  SortType sortType = SortType.alfabetic;
  SortOrder sortOrder = SortOrder.asc;
  bool isCreate = true;
  DateTime? createdAt;
  OrdemFreezedCreateModel freezed = OrdemFreezedCreateModel();
  MateriaPrimaModel? materiaPrima;
  int? beltIndex;

  late bool isEdit;

  OrdemCreateModel()
    : id =
          '${[...FirestoreClient.ordens.dataStream.value].length + 1}_${HashService.get}',
      isEdit = false,
      isCreate = true;

  OrdemCreateModel.edit(OrdemModel ordem) : id = ordem.id, isEdit = true {
    isCreate = false;
    createdAt = ordem.createdAt;
    produto = FirestoreClient.produtos.data.firstWhere(
      (e) => e.id == ordem.produto.id,
    );
    produtos = ordem.produtos
        .map(
          (e) =>
              e.copyWith(isSelected: true, isAvailable: e.isAvailableToChanges),
        )
        .toList();
    freezed = OrdemFreezedCreateModel.edit(ordem.freezed);
    beltIndex = ordem.beltIndex;
    if (ordem.materiaPrima != null) {
      materiaPrima = FirestoreClient.materiaPrimas.getById(
        ordem.materiaPrima!.id,
      );
    }
  }

  OrdemModel toOrdemModel() {
    return OrdemModel(
      id: id,
      createdAt: createdAt ?? DateTime.now(),
      produto: produto!,
      produtos: produtos
          .map(
            (e) => e.copyWith(
              statusess: [
                ...e.statusess,
                if (e.statusess.last.status !=
                    PedidoProdutoStatus.aguardandoProducao)
                  if (e.isSelected && e.isAvailableToChanges)
                    PedidoProdutoStatusModel.create(
                      PedidoProdutoStatus.aguardandoProducao,
                    ),
              ],
            ),
          )
          .toList(),
      freezed: isCreate ? OrdemFreezedModel.static() : freezed.toOrdemFreeze(),
      beltIndex: isCreate
          ? FirestoreClient.ordens.ordensNaoCongeladas.length
          : beltIndex,
      materiaPrima: materiaPrima?.id == 'register_unavailable'
          ? null
          : materiaPrima,
      updatedAt: DateTime.now(),
    );
  }
}

class OrdemFreezedCreateModel {
  TextController reason = TextController();
  bool isFreezed = false;
  DateTime updatedAt = DateTime.now();

  late bool isEdit;

  OrdemFreezedCreateModel() : isEdit = false;

  OrdemFreezedCreateModel.edit(OrdemFreezedModel freezed) : isEdit = true {
    isFreezed = freezed.isFreezed;
    reason = TextController(text: freezed.reason.text);
    updatedAt = freezed.updatedAt;
  }

  OrdemFreezedModel toOrdemFreeze() {
    return OrdemFreezedModel(
      isFreezed: isFreezed,
      reason: reason,
      updatedAt: updatedAt,
    );
  }
}

class OrdemEtiquetaModel {
  final ClienteModel cliente;
  final ObraModel obra;
  final PedidoModel pedido;
  final OrdemModel ordem;
  final DateTime createdAt;
  final PedidoProdutoModel produto;

  OrdemEtiquetaModel({
    required this.cliente,
    required this.obra,
    required this.pedido,
    required this.ordem,
    required this.createdAt,
    required this.produto,
  });
}
