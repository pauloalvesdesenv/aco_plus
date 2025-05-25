enum SortType { alfabetic, createdAt, deliveryAt, localizator, client, qtde }

extension SortTypeExt on SortType {
  String get name {
    switch (this) {
      case SortType.alfabetic:
        return 'Alfabética';
      case SortType.createdAt:
        return 'Data Criação';
      case SortType.deliveryAt:
        return 'Previsão de Entrega';
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
  String get name {
    switch (this) {
      case SortOrder.asc:
        return 'Crescente';
      case SortOrder.desc:
        return 'Decrescente';
    }
  }
}
