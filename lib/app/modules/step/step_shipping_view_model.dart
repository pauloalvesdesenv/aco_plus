import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_shipping_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';

class StepShippingCreateModel {
  TextController description = TextController();

  StepShippingCreateModel();

  StepShippingCreateModel.edit(StepShippingModel shipping) {
    description.text = shipping.description;
  }

  StepShippingModel toStepShippingModel() => StepShippingModel(
        description: description.text,
      );
}
