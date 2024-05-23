import 'package:flutter/material.dart';

enum PedidoTipo { cd, cda }

extension PedidoTipoExtension on PedidoTipo {
  String get label {
    switch (this) {
      case PedidoTipo.cd:
        return 'Corte e Dobra';
      case PedidoTipo.cda:
        return 'Corte, Dobra e Armação';
    }
  }

  Color get foregroundColor {
    switch (this) {
      case PedidoTipo.cd:
        return Colors.red;
      case PedidoTipo.cda:
        return Colors.green;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PedidoTipo.cd:
        return Colors.red[100]!;
      case PedidoTipo.cda:
        return Colors.green[100]!;
    }
  }
}
