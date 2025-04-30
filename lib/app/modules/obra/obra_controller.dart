import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/modules/obra/obra_view_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

final obraCtrl = ObraController();

class ObraController {
  static final ObraController _instance = ObraController._();

  ObraController._();

  factory ObraController() => _instance;

  final AppStream<ObraCreateModel> formStream = AppStream<ObraCreateModel>();
  ObraCreateModel get form => formStream.value;

  void init(ObraModel? obra, EnderecoModel? enderecoModel) {
    formStream
        .add(obra != null ? ObraCreateModel.edit(obra) : ObraCreateModel());
    if (!form.isEdit) {
      form.endereco = enderecoModel;
      formStream.update();
    }
  }

  Future<void> onConfirm(_) async {
    try {
      onValid();
      Navigator.pop(_, formStream.value.toObraModel());
      NotificationService.showPositive(
          'Obra ${form.isEdit ? 'Editada' : 'Adicionada'}',
          'Operação realizada com sucesso',
          position: NotificationPosition.bottom);
    } catch (e) {
      NotificationService.showNegative('Erro', e.toString(),
          position: NotificationPosition.bottom);
    }
  }

  void onValid() {
    if (form.descricao.text.length < 2) {
      throw Exception('Descrição deve conter no mínimo 3 caracteres');
    }
    if (form.status == null) {
      throw Exception('Selecione um status para a obra');
    }
  }
}
