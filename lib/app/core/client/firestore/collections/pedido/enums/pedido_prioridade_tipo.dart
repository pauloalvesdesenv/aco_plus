import 'package:flutter/material.dart';

enum PedidoPrioridadeTipo { cd, armacao, expedicao }

extension PedidoPrioridadeTipoExt on PedidoPrioridadeTipo {
  String getLabel() {
    switch (this) {
      case PedidoPrioridadeTipo.cd:
        return 'Corte e Dobra';
      case PedidoPrioridadeTipo.armacao:
        return 'Armação';
      case PedidoPrioridadeTipo.expedicao:
        return 'Expedição';
    }
  }

  String getLabelShort() {
    switch (this) {
      case PedidoPrioridadeTipo.cd:
        return 'CD';
      case PedidoPrioridadeTipo.armacao:
        return 'ARM';
      case PedidoPrioridadeTipo.expedicao:
        return 'EXP';
    }
  }

  IconData getIcon() {
    switch (this) {
      case PedidoPrioridadeTipo.cd:
        return Icons.content_cut;
      case PedidoPrioridadeTipo.armacao:
        return Icons.construction;
      case PedidoPrioridadeTipo.expedicao:
        return Icons.local_shipping;
    }
  }
}
