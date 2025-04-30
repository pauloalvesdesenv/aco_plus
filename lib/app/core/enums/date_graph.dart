enum DateGraph { day, week, month, year, all }

extension DateGraphExtension on DateGraph {
  String get name {
    switch (this) {
      case DateGraph.day:
        return 'Dia';
      case DateGraph.week:
        return 'Semana';
      case DateGraph.month:
        return 'Mês';
      case DateGraph.year:
        return 'Ano';
      case DateGraph.all:
        return 'Todos';
    }
  }

  DateTime get start {
    final __ = DateTime.now();
    final now = DateTime(__.year, __.month, __.day, 0, 0, 0, 0);

    switch (this) {
      case DateGraph.day:
        return now;
      case DateGraph.week:
        return now.subtract(Duration(days: now.weekday - 1));
      case DateGraph.month:
        return DateTime(__.year, __.month, 1);
      case DateGraph.year:
        return DateTime(__.year, 1, 1);
      case DateGraph.all:
        return DateTime(2020, 1, 1);
    }
  }
}
