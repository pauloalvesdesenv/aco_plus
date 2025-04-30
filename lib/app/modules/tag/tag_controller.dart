import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/models/app_stream.dart';
import 'package:aco_plus/app/core/services/notification_service.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/tag/tag_view_model.dart';
import 'package:overlay_support/overlay_support.dart';

final tagCtrl = TagController();
TagModel get tag => tagCtrl.tag!;

class TagController {
  static final TagController _instance = TagController._();

  TagController._();

  factory TagController() => _instance;

  final AppStream<TagModel?> tagStream = AppStream<TagModel?>.seed(null);
  TagModel? get tag => tagStream.value;

  final AppStream<TagUtils> utilsStream = AppStream<TagUtils>.seed(TagUtils());
  TagUtils get utils => utilsStream.value;

  void onInit() {
    utilsStream.add(TagUtils());
    FirestoreClient.tags.fetch();
  }

  final AppStream<TagCreateModel> formStream = AppStream<TagCreateModel>();
  TagCreateModel get form => formStream.value;

  void init(TagModel? tag) {
    formStream.add(tag != null ? TagCreateModel.edit(tag) : TagCreateModel());
  }

  List<TagModel> getTagsFiltered(String search, List<TagModel> tags) {
    if (search.length < 3) return tags;
    List<TagModel> filtered = [];
    for (final tag in tags) {
      if (tag.toString().toCompare.contains(search.toCompare)) {
        filtered.add(tag);
      }
    }
    return filtered;
  }

  Future<void> onConfirm(value, TagModel? tag) async {
    try {
      onValid(tag);
      if (form.isEdit) {
        final edit = form.toTagModel();
        await FirestoreClient.tags.update(edit);
      } else {
        await FirestoreClient.tags.add(form.toTagModel());
      }
      pop(value);

      NotificationService.showPositive(
        'Etiqueta ${form.isEdit ? 'Editada' : 'Adicionada'}',
        'Operação realizada com sucesso',
        position: NotificationPosition.bottom,
      );
      await FirestoreClient.tags.fetch();
    } catch (e) {
      NotificationService.showNegative(
        'Erro',
        e.toString(),
        position: NotificationPosition.bottom,
      );
    }
  }

  Future<void> onDelete(value, TagModel tag) async {
    await FirestoreClient.tags.delete(tag);
    pop(value);
    NotificationService.showPositive(
      'Etiqueta Excluida',
      'Operação realizada com sucesso',
      position: NotificationPosition.bottom,
    );
    await FirestoreClient.tags.fetch();
  }

  void onValid(TagModel? tag) {}
}
