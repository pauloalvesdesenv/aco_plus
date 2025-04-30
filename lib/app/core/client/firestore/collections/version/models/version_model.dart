import 'dart:convert';

class VersionModel {
  final double number;
  VersionModel({required this.number});

  VersionModel copyWith({double? number}) {
    return VersionModel(number: number ?? this.number);
  }

  Map<String, dynamic> toMap() {
    return {'number': number};
  }

  factory VersionModel.fromMap(Map<String, dynamic> map) {
    return VersionModel(number: map['number']?.toDouble() ?? 0.0);
  }

  String toJson() => json.encode(toMap());

  factory VersionModel.fromJson(String source) =>
      VersionModel.fromMap(json.decode(source));

  @override
  String toString() => 'VersionModel(number: $number)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VersionModel && other.number == number;
  }

  @override
  int get hashCode => number.hashCode;
}
