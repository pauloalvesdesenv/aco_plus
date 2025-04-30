import 'dart:convert';

class StepShippingModel {
  final String description;
  StepShippingModel({required this.description});

  StepShippingModel copyWith({String? description}) {
    return StepShippingModel(description: description ?? this.description);
  }

  Map<String, dynamic> toMap() {
    return {'description': description};
  }

  factory StepShippingModel.fromMap(Map<String, dynamic> map) {
    return StepShippingModel(description: map['description'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory StepShippingModel.fromJson(String source) =>
      StepShippingModel.fromMap(json.decode(source));

  @override
  String toString() => 'StepShippingModel(description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StepShippingModel && other.description == description;
  }

  @override
  int get hashCode => description.hashCode;
}
