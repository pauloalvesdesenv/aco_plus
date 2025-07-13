import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum RelatorioProducaoPdfExportarTipo { completo, resumido }

extension RelatorioProducaoPdfExportarTipoExtension
    on RelatorioProducaoPdfExportarTipo {
  String get label => switch (this) {
    RelatorioProducaoPdfExportarTipo.completo => 'Completo',
    RelatorioProducaoPdfExportarTipo.resumido => 'Resumido',
  };

  String get descricao => switch (this) {
    RelatorioProducaoPdfExportarTipo.completo =>
      'Relatório completo com todas as bitolas',
    RelatorioProducaoPdfExportarTipo.resumido =>
      'Relatório resumido sem as bitolas',
  };

  IconData get icon => switch (this) {
    RelatorioProducaoPdfExportarTipo.completo => Icons.description,
    RelatorioProducaoPdfExportarTipo.resumido => Icons.description_outlined,
  };
}

enum RelatorioProducaoStatus { AGUARDANDO_PRODUCAO, EM_PRODUCAO, PRODUZIDAS }

extension RelatorioProducaoStatusExt on RelatorioProducaoStatus {
  String get label {
    switch (this) {
      case RelatorioProducaoStatus.AGUARDANDO_PRODUCAO:
        return 'Aguardando Produção';
      case RelatorioProducaoStatus.EM_PRODUCAO:
        return 'Em Produção';
      case RelatorioProducaoStatus.PRODUZIDAS:
        return 'Produzidas';
    }
  }

  Color get color {
    switch (this) {
      case RelatorioProducaoStatus.AGUARDANDO_PRODUCAO:
        return AppColors.primaryMain;
      case RelatorioProducaoStatus.EM_PRODUCAO:
        return Colors.orange;
      case RelatorioProducaoStatus.PRODUZIDAS:
        return Colors.green;
    }
  }
}

class RelatorioProducaoViewModel {
  late List<ProdutoModel> produtos;
  DateTimeRange? dates = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 5)),
    end: DateTime.now(),
  );
  TextController localizadorEC = TextController();
  RelatorioProducaoModel? relatorio;

  RelatorioProducaoViewModel.create() {
    produtos = FirestoreClient.produtos.data.map((e) => e.copyWith()).toList();
  }
}

class RelatorioProducaoModel {
  late List<OrdemModel> ordens;
  late DateTimeRange? dates;
  late String localizador;
  final DateTime createdAt = DateTime.now();
  final List<PedidoProdutoTurno> turnos;

  RelatorioProducaoModel({
    required this.ordens,
    required this.dates,
    required this.localizador,
    required this.turnos,
  });
}
