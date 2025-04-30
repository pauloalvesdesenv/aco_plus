import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KanbanCalendarWeekdayWidget extends StatelessWidget {
  final DateTime day;
  const KanbanCalendarWeekdayWidget(this.day, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[400]!, width: 0.5),
      ),
      child: Center(
        child: Text(
          DateFormat('E').format(day).toUpperCase(),
          style: AppCss.minimumRegular.copyWith(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 11,
            height: 1,
          ),
        ),
      ),
    );
  }
}
