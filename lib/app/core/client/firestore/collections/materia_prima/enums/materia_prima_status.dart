import 'package:flutter/material.dart';

enum MateriaPrimaStatus { disponivel, finalizada }

extension MateriaPrimaStatusExtension on MateriaPrimaStatus {
  String get label {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return 'Disponível';
      case MateriaPrimaStatus.finalizada:
        return 'Finalizada';
    }
  }

  Color get color {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return Colors.green;
      case MateriaPrimaStatus.finalizada:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case MateriaPrimaStatus.disponivel:
        return Icons.check;
      case MateriaPrimaStatus.finalizada:
        return Icons.check;
    }
  }
}
