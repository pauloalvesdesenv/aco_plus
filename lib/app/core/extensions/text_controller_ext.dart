import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:intl/intl.dart';

extension TextControllerExt on TextController {
  double get doubleValue => double.tryParse(text.replaceAll(',', '.')) ?? 0;
  int get intValue => int.tryParse(text) ?? 0;
  DateTime get ddMMyyyy {
    try {
      final format = DateFormat('dd/MM/yyyy');
      return format.parse(text);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get labelValue =>
      (double.tryParse(text) ?? 0).toString().replaceAll('.0', '');
}
