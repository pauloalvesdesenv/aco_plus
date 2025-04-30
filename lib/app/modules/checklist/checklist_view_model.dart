import 'package:aco_plus/app/core/client/firestore/collections/checklist/models/checklist_model.dart';
import 'package:aco_plus/app/core/components/checklist/check_item_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';

class ChecklistUtils {
  final TextController search = TextController();
}

class ChecklistCreateModel {
  final String id;
  TextController nome = TextController();
  List<CheckItemModel> checklist = [];
  DateTime createdAt = DateTime.now();

  late bool isEdit;

  ChecklistCreateModel() : id = HashService.get, isEdit = false;

  ChecklistCreateModel.edit(ChecklistModel tag) : id = tag.id, isEdit = true {
    checklist = tag.checklist;
    createdAt = tag.createdAt;
    nome.text = tag.nome;
  }

  ChecklistModel toChecklistModel() => ChecklistModel(
    id: id,
    nome: nome.text,
    checklist: checklist,
    createdAt: createdAt,
  );
}
