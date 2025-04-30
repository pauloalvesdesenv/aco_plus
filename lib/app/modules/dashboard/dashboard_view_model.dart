enum DashboardClienteRankingType { pedidos, kilos }

extension DashboardClienteRankingTypeExt on DashboardClienteRankingType {
  String get label {
    switch (this) {
      case DashboardClienteRankingType.pedidos:
        return 'Pedidos';
      case DashboardClienteRankingType.kilos:
        return 'Kilos';
    }
  }
}

class DashboardUtils {
  DashboardClienteRankingType clienteRankingType =
      DashboardClienteRankingType.values.first;
}

class RankingModel<T> {
  T model;
  String value;

  RankingModel({required this.model, required this.value});
}
