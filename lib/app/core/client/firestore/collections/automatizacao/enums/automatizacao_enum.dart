enum AutomatizacaoItemType {
  CRIACAO_PEDIDO,
  PRODUTO_PEDIDO_SEPARADO,
  PRODUZINDO_CD_PEDIDO,
  PRONTO_CD_PEDIDO,
  AGUARDANDO_ARMACAO_PEDIDO,
  PRODUZINDO_ARMACAO_PEDIDO,
  PRONTO_ARMACAO_PEDIDO,
  NAO_MOSTRAR_NO_CALENDARIO,
  REMOVER_LISTA_PRIORIDADE,
}

extension AutomatizacaoItemTypeExtension on AutomatizacaoItemType {
  String get label {
    switch (this) {
      case AutomatizacaoItemType.CRIACAO_PEDIDO:
        return 'Criação do pedido';
      case AutomatizacaoItemType.PRODUTO_PEDIDO_SEPARADO:
        return 'Produto do pedido separado';
      case AutomatizacaoItemType.PRODUZINDO_CD_PEDIDO:
        return 'Produzindo CD do pedido';
      case AutomatizacaoItemType.PRONTO_CD_PEDIDO:
        return 'CD do pedido pronto';
      case AutomatizacaoItemType.AGUARDANDO_ARMACAO_PEDIDO:
        return 'Aguardando armação do pedido';
      case AutomatizacaoItemType.PRODUZINDO_ARMACAO_PEDIDO:
        return 'Produzindo armação do pedido';
      case AutomatizacaoItemType.PRONTO_ARMACAO_PEDIDO:
        return 'Armação do pedido pronta';
      case AutomatizacaoItemType.NAO_MOSTRAR_NO_CALENDARIO:
        return 'Não mostrar no calendário';
      case AutomatizacaoItemType.REMOVER_LISTA_PRIORIDADE:
        return 'Remover da lista de prioridade';
    }
  }

  String get desc {
    switch (this) {
      case AutomatizacaoItemType.CRIACAO_PEDIDO:
        return 'Pedido é inserido no sistema';
      case AutomatizacaoItemType.PRODUTO_PEDIDO_SEPARADO:
        return 'Bitolas separadas em uma ordem de produção';
      case AutomatizacaoItemType.PRODUZINDO_CD_PEDIDO:
        return 'Primeiro vergalhão é separado para produção';
      case AutomatizacaoItemType.PRONTO_CD_PEDIDO:
        return 'Pedido apenas de Corte e Dobra pronto';
      case AutomatizacaoItemType.AGUARDANDO_ARMACAO_PEDIDO:
        return 'Armação é solicitada';
      case AutomatizacaoItemType.PRODUZINDO_ARMACAO_PEDIDO:
        return 'Armação começa a ser produzida';
      case AutomatizacaoItemType.PRONTO_ARMACAO_PEDIDO:
        return 'Armação está pronta';
      case AutomatizacaoItemType.NAO_MOSTRAR_NO_CALENDARIO:
        return 'Ao cair em alguma das etapas na lista, não será exibido no calendário';
      case AutomatizacaoItemType.REMOVER_LISTA_PRIORIDADE:
        return 'Ao cair em alguma das etapas na lista, será removido da lista de prioridade';
    }
  }
}
