import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_arquivada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_concluida_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_congelada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_criada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_desarquivada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_descongelada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_editada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_status_produto_model.dart';

class OrdemHistoryModel {
  final OrdemHistoryTypeEnum type;
  final String message;
  final DateTime createdAt;
  final OrdemHistoryDataModel data;

  OrdemHistoryModel({
    required this.type,
    required this.message,
    required this.createdAt,
    required this.data,
  });

  factory OrdemHistoryModel.fromJson(Map<String, dynamic> json) {
    late OrdemHistoryDataModel data;
    final OrdemHistoryTypeEnum type = OrdemHistoryTypeEnum.values.byName(
      json['type'],
    );

    switch (type) {
      case OrdemHistoryTypeEnum.criada:
        data = OrdemHistoryTypeCriadaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.editada:
        data = OrdemHistoryTypeEditadaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.congelada:
        data = OrdemHistoryTypeCongeladaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.descongelada:
        data = OrdemHistoryTypeDescongeladaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.statusProdutoAlterada:
        data = OrdemHistoryTypeStatusProdutoModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.materiaPrimaEditada:
        data = OrdemHistoryTypeMateriaPrimaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.concluida:
        data = OrdemHistoryTypeConcluidaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.arquivada:
        data = OrdemHistoryTypeArquivadaModel.fromJson(json['data']);
        break;
      case OrdemHistoryTypeEnum.desarquivada:
        data = OrdemHistoryTypeDesarquivadaModel.fromJson(json['data']);
        break;
    }

    return OrdemHistoryModel(
      type: type,
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'data': data.toJson(),
    };
  }
}

abstract class OrdemHistoryDataModel {
  Map<String, dynamic> toJson();
}
