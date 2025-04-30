import 'dart:typed_data';

import 'package:aco_plus/app/core/services/firebase_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<bool> backupDownload(String name, String path, Uint8List bytes) async {
  try {
    final result = await FirebaseService.uploadFile(
      name: name,
      bytes: bytes,
      mimeType: 'application/json',
      path: path,
    );
    await launchUrlString(result, mode: LaunchMode.externalApplication);
    return true;
  } catch (_) {
    return false;
  }
}
