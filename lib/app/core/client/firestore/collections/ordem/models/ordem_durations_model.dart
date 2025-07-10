import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:collection/collection.dart';

class OrdemDurationsModel {
  final DateTime startedAt;
  final DateTime? endedAt;

  OrdemDurationsModel({required this.startedAt, this.endedAt});

  static OrdemDurationsModel? getByOrdem(OrdemModel ordem) {
    final started = ordem.history.firstWhereOrNull(
      (e) => e.type == OrdemHistoryTypeEnum.criada,
    );
    if (started == null) return null;
    final ended = ordem.history.firstWhereOrNull(
      (e) => e.type == OrdemHistoryTypeEnum.statusOrdem,
    );

    return OrdemDurationsModel(
      startedAt: started.createdAt,
      endedAt: ended?.createdAt,
    );
  }
}
