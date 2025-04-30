import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class BackupUtils {
  String restoreTitle = 'Restaurar Backup';
  int restoreLenght = 0;
  int restoreIndex = 0;
}

class BackupModel {
  final String nome;
  final DateTime createdAt;
  late String url;

  BackupModel({required this.nome, required this.createdAt});

  factory BackupModel.fromRef(Reference ref) {
    final createdAt = DateFormat(
      'dd_MM_yyyy_hh_mm_ss',
    ).parse(ref.name.split('.').first.split('backup_').last);
    return BackupModel(nome: ref.name, createdAt: createdAt);
  }
}
