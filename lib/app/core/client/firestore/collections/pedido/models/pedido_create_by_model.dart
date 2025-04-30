import 'dart:convert';

class PedidoCreateByModel {
  final String name;
  final DateTime date;
  PedidoCreateByModel({required this.name, required this.date});

  PedidoCreateByModel copyWith({String? name, DateTime? date}) {
    return PedidoCreateByModel(
      name: name ?? this.name,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'date': date.millisecondsSinceEpoch};
  }

  factory PedidoCreateByModel.fromMap(Map<String, dynamic> map) {
    return PedidoCreateByModel(
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoCreateByModel.fromJson(String source) =>
      PedidoCreateByModel.fromMap(json.decode(source));

  @override
  String toString() => 'PedidoCreateByModel(name: $name, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PedidoCreateByModel &&
        other.name == name &&
        other.date == date;
  }

  @override
  int get hashCode => name.hashCode ^ date.hashCode;
}
