import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/fabricante/fabricante_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final fabricanteCtrl = FabricanteController();
FabricanteModel get fabricante => fabricanteCtrl.fabricante!;

class FabricanteController {
  static final FabricanteController _instance = FabricanteController._();

  FabricanteController._();

  factory FabricanteController() => _instance;

  final AppStream<FabricanteModel?> fabricanteStream =
      AppStream<FabricanteModel?>.seed(null);
  FabricanteModel? get fabricante => fabricanteStream.value;

  final AppStream<FabricanteUtils> utilsStream =
      AppStream<FabricanteUtils>.seed(FabricanteUtils());
  FabricanteUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(FabricanteUtils());
    FirestoreClient.fabricantes.fetch();
  }

  final AppStream<FabricanteCreateModel> formStream =
      AppStream<FabricanteCreateModel>();
  FabricanteCreateModel get form => formStream.value;

  void init(FabricanteModel? fabricante) {
    formStream.add(
      fabricante != null
          ? FabricanteCreateModel.edit(fabricante)
          : FabricanteCreateModel(),
    );
  }

  List<FabricanteModel> getFabricanteesFiltered(
    String search,
    List<FabricanteModel> fabricantes,
  ) {
    if (search.length < 3) return fabricantes;
    List<FabricanteModel> filtered = [];
    for (final fabricante in fabricantes) {
      if (fabricante.toString().toCompare.contains(search.toCompare)) {
        filtered.add(fabricante);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, FabricanteModel? fabricante) async {
    try {
      onValid(fabricante);
      if (form.isEdit) {
        final edit = form.toFabricanteModel();
        await FirestoreClient.fabricantes.update(edit);
      } else {
        await FirestoreClient.fabricantes.add(form.toFabricanteModel());
      }
      pop(value);
      NotificationService.showPositive(
        'Fabricante ${form.isEdit ? 'Editado' : 'Adicionado'}',
        'Operação realizada com sucesso',
        position: NotificationPosition.bottom,
      );
    } catch (e) {
      NotificationService.showNegative(
        'Erro',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onDelete(value, FabricanteModel fabricante) async {
    if (await _isDeleteUnavailable(fabricante)) return;
    await FirestoreClient.fabricantes.delete(fabricante);
    pop(value);
    NotificationService.showPositive(
      'Fabricante Excluido',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
  }

  Future<bool> _isDeleteUnavailable(
    FabricanteModel fabricante,
  ) async => !await onDeleteProcess(
    deleteTitle: 'Deseja excluir o fabricante?',
    deleteMessage: 'Todos seus dados serão apagados do sistema',
    infoMessage:
        'Não é possível exlcuir o fabricante, pois ele está vinculado a uma prdem.',
    conditional: FirestoreClient.ordens.data.any(
      (e) => e.materiaPrima?.fabricanteModel.id == fabricante.id,
    ),
  );

  void onValid(FabricanteModel? fabricante) {
    if (form.nome.text.length < 2) {
      throw Exception('Nome deve conter no mínimo 3 caracteres');
    }
    if (form.isEdit) {
      if (FirestoreClient.fabricantes.data.any(
        (e) => e.nome == form.nome.text,
      )) {
        throw Exception('Já existe um fabricante com esse nome');
      }
    }
  }
}
