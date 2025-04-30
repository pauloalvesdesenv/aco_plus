import 'package:flutter/material.dart';

enum ObraStatus { emAndamento, inativa, encerrada }

extension ObraStatusExt on ObraStatus {
  String get label {
    switch (this) {
      case ObraStatus.emAndamento:
        return 'Andamento';
      case ObraStatus.inativa:
        return 'Inativa';
      case ObraStatus.encerrada:
        return 'Encerrada';
    }
  }

  Color get color {
    switch (this) {
      case ObraStatus.emAndamento:
        return Colors.orange;
      case ObraStatus.inativa:
        return Colors.grey;
      case ObraStatus.encerrada:
        return Colors.green;
    }
  }
}
