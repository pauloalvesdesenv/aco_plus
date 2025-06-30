import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_criada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_status_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/ordem/ui/components/timeline/type/ordem_timeline_create_details.dart';
import 'package:aco_plus/app/modules/ordem/ui/components/timeline/type/ordem_timeline_status_produto_details.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrdemTimelineWidget extends StatefulWidget {
  final OrdemModel ordem;
  const OrdemTimelineWidget({super.key, required this.ordem});

  @override
  State<OrdemTimelineWidget> createState() => _OrdemTimelineWidgetState();
}

class _OrdemTimelineWidgetState extends State<OrdemTimelineWidget> {
  OrdemHistoryModel? item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Histórico', style: AppCss.largeBold),
        ),
        SizedBox(
          width: double.maxFinite,
          height: 25,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.ordem.history
                  .mapIndexed(
                    (index, e) => TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.center,
                      isFirst: index == 0,
                      isLast: widget.ordem.history.length == 1
                          ? false
                          : index == widget.ordem.history.length - 1,
                      indicatorStyle: IndicatorStyle(
                        height: 24,
                        width: 24,
                        indicator: InkWell(
                          onTap: () {
                            setState(() {
                              item = e;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primaryMain,
                              border: Border.all(
                                color: AppColors.primaryMain,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              e.type.getIcon(e.data),
                              color: e == item
                                  ? Colors.orangeAccent
                                  : Colors.white,
                              size: 15,
                              weight: FontWeight.bold.value.toDouble(),
                            ),
                          ),
                        ),
                      ),
                      beforeLineStyle: LineStyle(color: AppColors.primaryMain),
                      afterLineStyle: LineStyle(color: AppColors.primaryMain),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        if (item != null)
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryMain),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item!.type.getName(item!.data),
                        style: AppCss.mediumBold,
                      ),
                    ),
                    Text(
                      item!.createdAt.textHour(),
                      style: AppCss.smallRegular,
                    ),
                  ],
                ),
                Gap(8),
                switch (item!.type) {
                  OrdemHistoryTypeEnum.criada => OrdemTimelineCreateDetails(
                    data: item!.data as OrdemHistoryTypeCriadaModel,
                  ),
                  OrdemHistoryTypeEnum.statusProdutoAlterada =>
                    OrdemTimelineStatusProdutoDetails(
                      data: item!.data as OrdemHistoryTypeStatusProdutoModel,
                    ),
                  _ => Text(item!.data.toString(), style: AppCss.mediumRegular),
                },
              ],
            ),
          ),
        Gap(24),
      ],
    );
  }
}
