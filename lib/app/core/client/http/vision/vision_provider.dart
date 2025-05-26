import 'dart:io';

import 'package:googleapis/vision/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class VisionProvider {
  Future<String> getTextFromImage(String imageBase64) async {
    var credentials = ServiceAccountCredentials.fromJson(
      File('assets/google_service_account.json').readAsStringSync(),
    );

    var scopes = [VisionApi.cloudPlatformScope];

    var client = await clientViaServiceAccount(credentials, scopes);

    var vision = VisionApi(client);

    var request = AnnotateImageRequest(
      image: Image(content: imageBase64),
      features: [Feature(type: 'TEXT_DETECTION')],
    );

    var response = await vision.images.annotate(
      BatchAnnotateImagesRequest(requests: [request]),
    );

    var text = '';
    if (response.responses != null &&
        response.responses!.isNotEmpty &&
        response.responses![0].textAnnotations != null &&
        response.responses![0].textAnnotations!.isNotEmpty) {
      text = response.responses![0].textAnnotations![0].description ?? '';
    }

    return text;
  }
}
