import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/modules/graph/produto_produzido/produto_produzido_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final produtoProduzidoCtrl = ProdutoProduzidoController();

class ProdutoProduzidoController {
  static final ProdutoProduzidoController _instance =
      ProdutoProduzidoController._();

  ProdutoProduzidoController._();

  factory ProdutoProduzidoController() => _instance;

  List<BarSeries<ProdutoProduzidoModel, DateTime>> getSource() =>
      getDates(ProdutoProduzido.day).reversed
          .toList()
          .map(
            (e) => BarSeries<ProdutoProduzidoModel, DateTime>(
              dataSource: getKilosProduzidos(e),
              name: e.ddMMyyyy(),
              color: e.isSameDay(dayNow())
                  ? AppColors.primaryMain
                  : Colors.grey[400],
              yValueMapper: (ProdutoProduzidoModel data, _) => data.qtde as num,
              xValueMapper: (ProdutoProduzidoModel data, _) => data.date,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
          )
          .toList();

  List<DateTime> getDates(ProdutoProduzido produtoProduzido) {
    switch (produtoProduzido) {
      case ProdutoProduzido.day:
        return List.generate(7, (index) {
          return dayNow().subtract(Duration(days: index));
        });
      case ProdutoProduzido.week:
        return List.generate(30, (index) {
          return dayNow().subtract(Duration(days: index));
        });
      case ProdutoProduzido.month:
        return List.generate(365, (index) {
          return dayNow().subtract(Duration(days: index));
        });
    }
  }

  List<ProdutoProduzidoModel> getKilosProduzidos(DateTime date) {
    List<ProdutoProduzidoModel> produzidos = [];
    final ordens = FirestoreClient.ordens.data
        .map((e) => e.copyWith())
        .toList();
    for (OrdemModel ordem in ordens) {
      for (PedidoProdutoModel produto in ordem.produtos) {
        if (produto.status.status == PedidoProdutoStatus.pronto &&
            date.isSameDay(produto.status.createdAt)) {
          if (produzidos.map((e) => e.date).contains(date)) {
            final index = produzidos.indexWhere(
              (element) => element.date == date,
            );
            produzidos[index].qtde += produto.qtde;
          } else {
            produzidos.add(
              ProdutoProduzidoModel(
                date: DateTime(date.year, date.month, date.day),
                qtde: produto.qtde,
              ),
            );
          }
        }
      }
    }
    for (var item in produzidos) {
      item.date.add(const Duration(hours: 12));
    }
    return produzidos;
  }
}
