import 'package:flutter_masked_text2/flutter_masked_text2.dart';

extension DoubleExt on double {
  String get formatted {
    String stringValue = toString();
    if (stringValue.endsWith(".0")) {
      return stringValue.substring(0, stringValue.length - 2);
    } else {
      return stringValue;
    }
  }

  String get percent {
    String stringValue = toString();
    if (stringValue.endsWith(".0")) {
      return stringValue.substring(0, stringValue.length - 2);
    } else {
      return toStringAsFixed(1);
    }
  }

  String get percentPDF {
    return toStringAsFixed(0);
  }

  String toMoney() =>
      MoneyMaskedTextController(leftSymbol: 'R\$ ', initialValue: this).text;
}
