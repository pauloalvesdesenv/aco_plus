import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class TextController<T> {
  T? object;
  late TextEditingController controller;
  FocusNode focus = FocusNode();

  TextController({String? text, String? mask, this.object}) {
    if (mask != null) {
      controller = MaskedTextController(text: text, mask: mask);
    } else {
      controller = TextEditingController(text: text);
    }
  }

  TextController.number({double? value, this.object}) {
    controller = MoneyMaskedTextController(
      initialValue: value ?? 0,
      precision: 2,
    );
  }

  TextController.ddMMyyyy({String? text, this.object}) {
    controller = MaskedTextController(text: text, mask: '00/00/0000');
  }

  TextController.phone({String? text, this.object}) {
    controller = MaskedTextController(text: text, mask: '(00) 00000-0000');
  }
  TextController.cpf({String? text, this.object}) {
    controller = MaskedTextController(text: text, mask: '000.000.000-00');
  }
  TextController.cnpj({String? text, this.object}) {
    controller = MaskedTextController(text: text, mask: '00.000.000/0000-00');
  }
  TextController.cep({String? text, this.object}) {
    controller = MaskedTextController(text: text, mask: '00000-000');
  }

  String get text => controller.text;
  set text(String value) => controller.text = value;

  String? get mask =>
      (controller is MaskedTextController)
          ? (controller as MaskedTextController).mask
          : null;

  void updateMask(String mask) {
    (controller as MaskedTextController).updateMask(mask);
  }

  TextController.create(this.controller, this.focus);
}
