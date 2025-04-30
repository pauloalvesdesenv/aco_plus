import 'dart:async';

import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/graph/core/graph_model.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_controller.dart';
import 'package:aco_plus/app/modules/graph/ordem_total/graph_ordem_total_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphOrdemTotalWidget extends StatefulWidget {
  const GraphOrdemTotalWidget({super.key});

  @override
  State<GraphOrdemTotalWidget> createState() => _GrapOrdemhTotalWidgetState();
}

class _GrapOrdemhTotalWidgetState extends State<GraphOrdemTotalWidget> {
  late List<GraphModel> data;

  late StreamSubscription<List<PedidoModel>> pedidoStream;

  @override
  void initState() {
    graphOrdemTotalCtrl.filterStream.add(GraphOrdemTotalModel());
    data = graphOrdemTotalCtrl.getCirucularChart(graphOrdemTotalCtrl.filter);
    pedidoStream = FirestoreClient.pedidos.pedidosUnarchivedsStream.listen
        .listen((e) {
          setState(() {
            data = graphOrdemTotalCtrl.getCirucularChart(
              graphOrdemTotalCtrl.filter,
            );
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
    return StreamOut<GraphOrdemTotalModel>(
      stream: graphOrdemTotalCtrl.filterStream.listen,
      builder: (value, filter) => body(value, filter),
    );
  }

  Widget body(BuildContext context, GraphOrdemTotalModel filter) {
    return Column(
      children: [
        const H(16),
        Expanded(
          child: SfCircularChart(
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x : point.y Pedido(s)',
            ),
            enableMultiSelection: true,
            onDataLabelRender: (dataLabelArgs) {
              dataLabelArgs.textStyle = AppCss.smallBold.setColor(
                dataLabelArgs.color,
              );
            },
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
            ),
            series: <CircularSeries<GraphModel, String>>[
              PieSeries<GraphModel, String>(
                dataSource: data,
                name: 'Ordens',
                dataLabelMapper: (GraphModel data, _) => data.vol.toKg(),
                pointColorMapper: (GraphModel data, _) => data.color,
                xValueMapper: (GraphModel data, _) => data.label,
                yValueMapper: (GraphModel data, _) => data.length,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
                initialSelectedDataIndexes: const [1],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
