import 'package:flutter/material.dart';

enum OrdemHistoryTypeEnum {
  criada,
  editada,
  congelada,
  descongelada,
  statusProdutoAlterada,
  materiaPrimaEditada,
  concluida,
  arquivada,
  desarquivada,
}

extension OrdemHistoryTypeEnumExtension on OrdemHistoryTypeEnum {
  IconData getIcon() {
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
        return Icons.check_circle;
      case OrdemHistoryTypeEnum.materiaPrimaEditada:
        return Icons.check_circle;
      case OrdemHistoryTypeEnum.concluida:
        return Icons.check_circle;
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
      case OrdemHistoryTypeEnum.concluida:
        return Colors.green;
      case OrdemHistoryTypeEnum.arquivada:
        return Colors.red;
      case OrdemHistoryTypeEnum.desarquivada:
        return Colors.green;
    }
  }
}
