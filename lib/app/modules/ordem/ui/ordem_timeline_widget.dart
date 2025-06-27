import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrdemTimelineWidget extends StatelessWidget {
  final OrdemModel ordem;
  const OrdemTimelineWidget({super.key, required this.ordem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: Row(
        children: ordem.history
            .mapIndexed(
              (index, e) => TimelineTile(
                axis: TimelineAxis.horizontal,
                alignment: _getAlignment(ordem.history, index),
                isFirst: index == 0,
                isLast: ordem.history.length == 1
                    ? false
                    : index == ordem.history.length - 1,
                indicatorStyle: IndicatorStyle(
                  height: 20,
                  width: 20,
                  indicator: Container(
                    padding: const EdgeInsets.all(2),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryMain,
                        width: 0.3,
                      ),
                      color: e.type.getBackgroundColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      e.type.getIcon(),
                      color: Colors.white,
                      size: 14,
                      weight: FontWeight.bold.value.toDouble(),
                    ),
                  ),
                ),
                beforeLineStyle: LineStyle(color: AppColors.primaryMain),
                afterLineStyle: LineStyle(color: AppColors.primaryMain),
              ),
            )
            .toList(),
      ),
    );
  }

  TimelineAlign _getAlignment(List<OrdemHistoryModel> history, int index) {
    if (index == 0) {
      return TimelineAlign.start;
    }
    if (index == history.length - 1) {
      return TimelineAlign.end;
    }
    return TimelineAlign.center;
  }
}
