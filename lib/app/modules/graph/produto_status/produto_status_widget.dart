import 'dart:async';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/graph/produto_status/produto_status_controller.dart';
import 'package:aco_plus/app/modules/graph/produto_status/produto_status_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProdutoStatusWidget extends StatefulWidget {
  const ProdutoStatusWidget({super.key});

  @override
  State<ProdutoStatusWidget> createState() => _GrapOrdemhTotalWidgetState();
}

class _GrapOrdemhTotalWidgetState extends State<ProdutoStatusWidget> {
  late StreamSubscription<List<PedidoModel>> pedidoStream;

  late List<ColumnSeries<ProdutoStatusGraphModel, String>> data;

  @override
  void initState() {
    data = produtoStatusCtrl.getSource();
    pedidoStream = FirestoreClient.pedidos.pedidosUnarchivedsStream.listen
        .listen((e) {
          setState(() {
            data = produtoStatusCtrl.getSource();
          });
        });
    super.initState();
  }

  @override
  void dispose() {
    pedidoStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const H(16),
        Expanded(
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              enableSelectionZooming: true,
              enableDoubleTapZooming: true,
              enableMouseWheelZooming: true,
              zoomMode: ZoomMode.xy,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x : point.y Kg',
            ),
            enableMultiSelection: true,
            onDataLabelRender: (dataLabelArgs) {
              dataLabelArgs.textStyle = AppCss.smallRegular.copyWith(
                color: dataLabelArgs.color,
                fontSize: 12,
              );
              double qtde = double.parse(dataLabelArgs.text ?? '0');
              dataLabelArgs.text =
                  qtde == 0 ? empty : qtde.toKg().replaceAll('Kg', '');
            },
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
            ),
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: NumericAxis(
              axisLabelFormatter: (axisLabelRenderArgs) {
                return ChartAxisLabel(
                  axisLabelRenderArgs.value.toDouble().toKg(),
                  AppCss.smallRegular.copyWith(fontSize: 12),
                );
              },
            ),
            series: data,
          ),
        ),
      ],
    );
  }
}
