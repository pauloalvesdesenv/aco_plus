import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';

class OrdemTimelineRegister {
  final OrdemModel ordem;

  OrdemTimelineRegister({required this.ordem});

  Future<void> register({
    required String ordemId,
    required OrdemHistoryTypeEnum type,
    required String message,
    required DateTime createdAt,
    required OrdemHistoryDataModel data,
  }) async {
    final history = OrdemHistoryModel(
      type: type,
      message: message,
      createdAt: createdAt,
      data: data,
    );
    ordem.history.add(history);
    await FirestoreClient.ordens.update(ordem);
  }
}
