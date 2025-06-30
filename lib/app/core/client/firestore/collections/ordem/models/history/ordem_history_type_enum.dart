import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_concluida_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:flutter/material.dart';

enum OrdemHistoryTypeEnum {
  criada, // OK
  editada, // OK
  congelada, // OK
  descongelada, // OK
  statusProdutoAlterada, // OK
  materiaPrimaEditada, // OK
  statusOrdem, // OK
  arquivada, // OK
  desarquivada, // OK
}

extension OrdemHistoryTypeEnumExtension on OrdemHistoryTypeEnum {
  IconData getIcon(OrdemHistoryDataModel data) {
    switch (this) {
      case OrdemHistoryTypeEnum.criada:
        return Icons.add;
      case OrdemHistoryTypeEnum.editada:
        return Icons.edit;
      case OrdemHistoryTypeEnum.congelada:
        return Icons.lock;
      case OrdemHistoryTypeEnum.descongelada:
        return Icons.lock_open;
      case OrdemHistoryTypeEnum.statusProdutoAlterada:
        return Icons.compare_arrows;
      case OrdemHistoryTypeEnum.materiaPrimaEditada:
        return Icons.change_circle;
      case OrdemHistoryTypeEnum.statusOrdem:
        if (data is OrdemHistoryTypeStatusOrdemModel) {
          if (data.status == PedidoProdutoStatus.pronto) {
            return Icons.check_circle;
          }
          if (data.status == PedidoProdutoStatus.produzindo) {
            return Icons.production_quantity_limits;
          }
        }
        return Icons.change_circle;
      case OrdemHistoryTypeEnum.arquivada:
        return Icons.archive;
      case OrdemHistoryTypeEnum.desarquivada:
        return Icons.archive;
    }
  }

  Color getBackgroundColor() {
    switch (this) {
      case OrdemHistoryTypeEnum.criada:
        return Colors.green;
      case OrdemHistoryTypeEnum.editada:
        return Colors.blue;
      case OrdemHistoryTypeEnum.congelada:
        return Colors.red;
      case OrdemHistoryTypeEnum.descongelada:
        return Colors.green;
      case OrdemHistoryTypeEnum.statusProdutoAlterada:
        return Colors.blue;
      case OrdemHistoryTypeEnum.materiaPrimaEditada:
        return Colors.green;
      case OrdemHistoryTypeEnum.statusOrdem:
        return Colors.green;
      case OrdemHistoryTypeEnum.arquivada:
        return Colors.red;
      case OrdemHistoryTypeEnum.desarquivada:
        return Colors.green;
    }
  }

  String getName(OrdemHistoryDataModel data) {
    switch (this) {
      case OrdemHistoryTypeEnum.criada:
        return 'Ordem criada';
      case OrdemHistoryTypeEnum.editada:
        return 'Ordem editada';
      case OrdemHistoryTypeEnum.congelada:
        return 'Ordem congelada';
      case OrdemHistoryTypeEnum.descongelada:
      case OrdemHistoryTypeEnum.statusProdutoAlterada:
        return 'Status do produto alterado';
      case OrdemHistoryTypeEnum.materiaPrimaEditada:
        return 'Materia prima editada';
      case OrdemHistoryTypeEnum.statusOrdem:
        return 'Status da ordem alterado';
      case OrdemHistoryTypeEnum.arquivada:
        return 'Ordem arquivada';
      case OrdemHistoryTypeEnum.desarquivada:
        return 'Ordem desarquivada';
    }
  }
}
