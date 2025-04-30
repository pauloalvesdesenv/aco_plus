import 'dart:convert';

class CheckItemModel {
  final String title;
  bool isCheck;
  CheckItemModel({required this.title, required this.isCheck});

  Map<String, dynamic> toMap() {
    return {'title': title, 'isCheck': isCheck};
  }

  factory CheckItemModel.fromMap(Map<String, dynamic> map) {
    return CheckItemModel(
      title: map['title'] ?? '',
      isCheck: map['isCheck'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckItemModel.fromJson(String source) =>
      CheckItemModel.fromMap(json.decode(source));

  CheckItemModel copyWith({String? title, bool? isCheck}) {
    return CheckItemModel(
      title: title ?? this.title,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
