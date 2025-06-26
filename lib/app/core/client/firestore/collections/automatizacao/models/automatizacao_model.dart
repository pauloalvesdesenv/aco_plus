import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/automatizacao/models/automatizacao_item_model.dart';

class AutomatizacaoModel {
  final AutomatizacaoItemModel criacaoPedido;
  final AutomatizacaoItemModel produtoPedidoSeparado;
  final AutomatizacaoItemModel produzindoCDPedido;
  final AutomatizacaoItemModel prontoCDPedido;
  final AutomatizacaoItemModel aguardandoArmacaoPedido;
  final AutomatizacaoItemModel produzindoArmacaoPedido;
  final AutomatizacaoItemModel prontoArmacaoPedido;
  final AutomatizacaoItemModel naoMostrarNoCalendario;

  List<AutomatizacaoItemModel> get itens => [
    criacaoPedido,
    produtoPedidoSeparado,
    produzindoCDPedido,
    prontoCDPedido,
    aguardandoArmacaoPedido,
    produzindoArmacaoPedido,
    prontoArmacaoPedido,
    naoMostrarNoCalendario,
  ];

  AutomatizacaoModel({
    required this.criacaoPedido,
    required this.produtoPedidoSeparado,
    required this.produzindoCDPedido,
    required this.prontoCDPedido,
    required this.aguardandoArmacaoPedido,
    required this.produzindoArmacaoPedido,
    required this.prontoArmacaoPedido,
    required this.naoMostrarNoCalendario,
  });

  AutomatizacaoModel copyWith({
    AutomatizacaoItemModel? criacaoPedido,
    AutomatizacaoItemModel? produtoPedidoSeparado,
    AutomatizacaoItemModel? produzindoCDPedido,
    AutomatizacaoItemModel? prontoCDPedido,
    AutomatizacaoItemModel? aguardandoArmacaoPedido,
    AutomatizacaoItemModel? produzindoArmacaoPedido,
    AutomatizacaoItemModel? prontoArmacaoPedido,
    AutomatizacaoItemModel? naoMostrarNoCalendario,
  }) {
    return AutomatizacaoModel(
      criacaoPedido: criacaoPedido ?? this.criacaoPedido,
      produtoPedidoSeparado:
          produtoPedidoSeparado ?? this.produtoPedidoSeparado,
      produzindoCDPedido: produzindoCDPedido ?? this.produzindoCDPedido,
      prontoCDPedido: prontoCDPedido ?? this.prontoCDPedido,
      aguardandoArmacaoPedido:
          aguardandoArmacaoPedido ?? this.aguardandoArmacaoPedido,
      produzindoArmacaoPedido:
          produzindoArmacaoPedido ?? this.produzindoArmacaoPedido,
      prontoArmacaoPedido: prontoArmacaoPedido ?? this.prontoArmacaoPedido,
      naoMostrarNoCalendario: naoMostrarNoCalendario ?? this.naoMostrarNoCalendario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'criacaoPedido': criacaoPedido.toMap(),
      'produtoPedidoSeparado': produtoPedidoSeparado.toMap(),
      'produzindoCDPedido': produzindoCDPedido.toMap(),
      'prontoCDPedido': prontoCDPedido.toMap(),
      'aguardandoArmacaoPedido': aguardandoArmacaoPedido.toMap(),
      'produzindoArmacaoPedido': produzindoArmacaoPedido.toMap(),
      'prontoArmacaoPedido': prontoArmacaoPedido.toMap(),
      'naoMostrarNoCalendario': naoMostrarNoCalendario.toMap(),
    };
  }

  factory AutomatizacaoModel.fromMap(Map<String, dynamic> map) {
    return AutomatizacaoModel(
      criacaoPedido: AutomatizacaoItemModel.fromMap(map['criacaoPedido']),
      produtoPedidoSeparado: AutomatizacaoItemModel.fromMap(
        map['produtoPedidoSeparado'],
      ),
      produzindoCDPedido: AutomatizacaoItemModel.fromMap(
        map['produzindoCDPedido'],
      ),
      prontoCDPedido: AutomatizacaoItemModel.fromMap(map['prontoCDPedido']),
      aguardandoArmacaoPedido: AutomatizacaoItemModel.fromMap(
        map['aguardandoArmacaoPedido'],
      ),
      produzindoArmacaoPedido: AutomatizacaoItemModel.fromMap(
        map['produzindoArmacaoPedido'],
      ),
      prontoArmacaoPedido: AutomatizacaoItemModel.fromMap(
        map['prontoArmacaoPedido'],
      ),
      naoMostrarNoCalendario: AutomatizacaoItemModel.fromMap(
        map['naoMostrarNoCalendario'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AutomatizacaoModel.fromJson(String source) =>
      AutomatizacaoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AutomatizacaoModel(criacaoPedido: $criacaoPedido, produzindoCDPedido: $produzindoCDPedido, prontoCDPedido: $prontoCDPedido, aguardandoArmacaoPedido: $aguardandoArmacaoPedido, produzindoArmacaoPedido: $produzindoArmacaoPedido, prontoArmacaoPedido: $prontoArmacaoPedido)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutomatizacaoModel &&
        other.criacaoPedido == criacaoPedido &&
        other.produzindoCDPedido == produzindoCDPedido &&
        other.prontoCDPedido == prontoCDPedido &&
        other.aguardandoArmacaoPedido == aguardandoArmacaoPedido &&
        other.produzindoArmacaoPedido == produzindoArmacaoPedido &&
        other.prontoArmacaoPedido == prontoArmacaoPedido;
  }

  @override
  int get hashCode {
    return criacaoPedido.hashCode ^
        produzindoCDPedido.hashCode ^
        prontoCDPedido.hashCode ^
        aguardandoArmacaoPedido.hashCode ^
        produzindoArmacaoPedido.hashCode ^
        prontoArmacaoPedido.hashCode;
  }
}
