import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/enums/sort_type.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum RelatorioOrdemType { STATUS, ORDEM }

extension RelatorioOrdemTypeExt on RelatorioOrdemType {
  String get label {
    switch (this) {
      case RelatorioOrdemType.STATUS:
        return 'Status';
      case RelatorioOrdemType.ORDEM:
        return 'Ordem';
    }
  }
}

enum RelatorioOrdemStatus { AGUARDANDO_PRODUCAO, EM_PRODUCAO, PRODUZIDAS }

extension RelatorioOrdemStatusExt on RelatorioOrdemStatus {
  String get label {
    switch (this) {
      case RelatorioOrdemStatus.AGUARDANDO_PRODUCAO:
        return 'Aguardando Produção';
      case RelatorioOrdemStatus.EM_PRODUCAO:
        return 'Em Produção';
      case RelatorioOrdemStatus.PRODUZIDAS:
        return 'Produzidas';
    }
  }

  Color get color {
    switch (this) {
      case RelatorioOrdemStatus.AGUARDANDO_PRODUCAO:
        return AppColors.primaryMain;
      case RelatorioOrdemStatus.EM_PRODUCAO:
        return Colors.orange;
      case RelatorioOrdemStatus.PRODUZIDAS:
        return Colors.green;
    }
  }
}

class RelatorioOrdemViewModel {
  RelatorioOrdemType? type = RelatorioOrdemType.STATUS;
  List<RelatorioOrdemStatus> status = [
    RelatorioOrdemStatus.AGUARDANDO_PRODUCAO,
    RelatorioOrdemStatus.EM_PRODUCAO,
  ];
  DateTimeRange? dates;
  RelatorioOrdemModel? relatorio;
  TextController ordemEC = TextController();
  OrdemModel? ordem;
  SortType sortType = SortType.alfabetic;
  SortOrder sortOrder = SortOrder.asc;
}

class RelatorioOrdemModel {
  late List<RelatorioOrdemStatus> status;
  late List<OrdemModel> ordens;
  late DateTimeRange? dates;
  late OrdemModel ordem;
  final DateTime createdAt = DateTime.now();

  RelatorioOrdemModel.status(this.status, this.ordens, {this.dates});
  RelatorioOrdemModel.ordem(this.ordem);
}
