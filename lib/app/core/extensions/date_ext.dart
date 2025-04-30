import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:intl/intl.dart';

DateTime dayNow() =>
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

extension DateExt on DateTime {
  String ddMMyyyy() => DateFormat('dd/MM/yyyy').format(this);

  bool isSameDay(DateTime date) =>
      DateTime(date.year, date.month, date.day) == DateTime(year, month, day);

  DateTime onlyDate({bool preserveDay = true}) =>
      DateTime(year, month, preserveDay ? day : 1);

  int get lastDay {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))
            ? 29
            : 28;
      default:
        throw ArgumentError();
    }
  }

  DateTime get previousMonth =>
      month == 1 ? DateTime(year - 1, 12, 1) : DateTime(year, month - 1, 1);

  DateTime get nextMonth =>
      month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, (month + 1));

  DateTime addMonths(int lenght) {
    DateTime now = this;
    for (var i = 0; i < lenght; i++) {
      now = now.nextMonth;
    }
    return now;
  }

  DateTime toLastDay() => DateTime(year, month, lastDay);

  DateTime getLastSunday() {
    for (var i = 0; i < 7; i++) {
      final value = subtract(Duration(days: day - i));
      if (value.weekday == 7) return value;
    }
    throw Exception();
  }

  String toFileName() =>
      DateFormat('dd_mm_yyyy_HH_mm').format(this).toLowerCase();

  String toddMM() => DateFormat('d \'de\' MMM').format(this);

  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 2) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(this);
    }
  }

  String textHour() => DateFormat("dd/MM/yyyy 'ás' HH:mm").format(this);
}

extension DateNullExt on DateTime? {
  TextController textEC() => TextController(text: text());
  String text() => this?.ddMMyyyy() ?? '';
  String textHour() =>
      this != null ? DateFormat("dd/MM/yyyy 'ás' HH:mm").format(this!) : '-';
}
