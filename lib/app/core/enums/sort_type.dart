enum SortType { alfabetic, createdAt, deliveryAt, localizator, client, qtde }

extension SortTypeExt on SortType {
  String get name {
    switch (this) {
      case SortType.alfabetic:
        return 'Alfabética';
      case SortType.createdAt:
        return 'Data de Criação';
      case SortType.deliveryAt:
        return 'Data de Entrega';
      case SortType.localizator:
        return 'Localizador';
      case SortType.client:
        return 'Cliente';
      case SortType.qtde:
        return 'Quantidade';
    }
  }
}

enum SortOrder { asc, desc }

extension SortOrderExt on SortOrder {
  String getName(SortType sortType) {
    switch (sortType) {
      case SortType.deliveryAt:
      switch (this) {
          case SortOrder.asc:
            return 'Mais proximo primeiro';
          case SortOrder.desc:
            return 'Mais distante primeiro';
        }
      case SortType.createdAt:
        switch (this) {
          case SortOrder.asc:
            return 'Mais recente primeiro';
          case SortOrder.desc:
            return 'Mais antigo primeiro';
        }
      default:
        switch (this) {
          case SortOrder.asc:
            return 'Crescente';
          case SortOrder.desc:
            return 'Decrescente';
        }
    }
  }
}
