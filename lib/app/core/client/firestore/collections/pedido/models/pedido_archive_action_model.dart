import 'dart:convert';

class PedidoArchiveActionModel {
  final bool isArchived;
  PedidoArchiveActionModel({required this.isArchived});

  PedidoArchiveActionModel copyWith({bool? isArchived}) {
    return PedidoArchiveActionModel(isArchived: isArchived ?? this.isArchived);
  }

  Map<String, dynamic> toMap() {
    return {'isArchived': isArchived};
  }

  factory PedidoArchiveActionModel.fromMap(Map<String, dynamic> map) {
    return PedidoArchiveActionModel(isArchived: map['isArchived'] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory PedidoArchiveActionModel.fromJson(String source) =>
      PedidoArchiveActionModel.fromMap(json.decode(source));

  @override
  String toString() => 'PedidoArchiveActionModel(isArchived: $isArchived)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PedidoArchiveActionModel && other.isArchived == isArchived;
  }

  @override
  int get hashCode => isArchived.hashCode;
}
