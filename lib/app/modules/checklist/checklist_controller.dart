import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/checklist/checklist_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final checklistCtrl = ChecklistController();
ChecklistModel get checklist => checklistCtrl.checklist!;

class ChecklistController {
  static final ChecklistController _instance = ChecklistController._();

  ChecklistController._();

  factory ChecklistController() => _instance;

  final AppStream<ChecklistModel?> checklistStream =
      AppStream<ChecklistModel?>.seed(null);
  ChecklistModel? get checklist => checklistStream.value;

  final AppStream<ChecklistUtils> utilsStream = AppStream<ChecklistUtils>.seed(
    ChecklistUtils(),
  );
  ChecklistUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(ChecklistUtils());
    FirestoreClient.checklists.fetch();
  }

  final AppStream<ChecklistCreateModel> formStream =
      AppStream<ChecklistCreateModel>();
  ChecklistCreateModel get form => formStream.value;

  void init(ChecklistModel? checklist) {
    formStream.add(
      checklist != null
          ? ChecklistCreateModel.edit(checklist)
          : ChecklistCreateModel(),
    );
  }

  List<ChecklistModel> getChecklistsFiltered(
    String search,
    List<ChecklistModel> checklists,
  ) {
    if (search.length < 3) return checklists;
    List<ChecklistModel> filtered = [];
    for (final checklist in checklists) {
      if (checklist.toString().toCompare.contains(search.toCompare)) {
        filtered.add(checklist);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, ChecklistModel? checklist) async {
    try {
      onValid(checklist);
      if (form.isEdit) {
        final edit = form.toChecklistModel();
        await FirestoreClient.checklists.update(edit);
      } else {
        await FirestoreClient.checklists.add(form.toChecklistModel());
      }
      pop(value);

      NotificationService.showPositive(
        'Etiqueta ${form.isEdit ? 'Editada' : 'Adicionada'}',
        'Operação realizada com sucesso',
        position: NotificationPosition.bottom,
      );
      await FirestoreClient.checklists.fetch();
    } catch (e) {
      NotificationService.showNegative(
        'Erro',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onDelete(value, ChecklistModel checklist) async {
    await FirestoreClient.checklists.delete(checklist);
    pop(value);
    NotificationService.showPositive(
      'Etiqueta Excluida',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
    await FirestoreClient.checklists.fetch();
  }

  void onValid(ChecklistModel? checklist) {}
}
