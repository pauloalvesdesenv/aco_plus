import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TagUtils {
  final TextController search = TextController();
}

class TagCreateModel {
  final String id;
  TextController nome = TextController();
  TextController descricao = TextController();
  Color color = AppColors.primaryMain;
  DateTime createdAt = DateTime.now();

  late bool isEdit;

  TagCreateModel() : id = HashService.get, isEdit = false;

  TagCreateModel.edit(TagModel tag) : id = tag.id, isEdit = true {
    nome.text = tag.nome;
    descricao.text = tag.descricao;
    color = tag.color;
    createdAt = tag.createdAt;
  }

  TagModel toTagModel() => TagModel(
    id: id,
    nome: nome.text,
    descricao: descricao.text,
    color: color,
    createdAt: createdAt,
  );
}
