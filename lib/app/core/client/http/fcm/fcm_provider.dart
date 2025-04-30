import 'package:aco_plus/app/core/client/firestore/collections/notificacao/notificacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/services/push_notification_service.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class FCMProvider {
  static Future<void> putToken() async {
    final token = await getDeviceToken();
    if (token == null || usuario.deviceTokens.contains(token)) return;
    usuario.deviceTokens.clear();
    usuario.deviceTokens.add(token);
    FirestoreClient.usuarios.update(usuario);
  }

  static Future<void> postSend(String userId, Map<String, dynamic> body) async {
    try {
      if (body['message']['token'] != null) {
        await Dio().post(
            'https://fcm.googleapis.com/v1/projects/aco-plus-fa455/messages:send',
            options: Options(headers: {
              'Authorization': 'Bearer ${await _getAccessToken()}',
              'Content-Type': 'application/json'
            }),
            data: body);
      }
      await FirestoreClient.notificacoes.add(
        NotificacaoModel.fromFCMMap(userId, body),
      );
    } catch (_) {
      return;
    }
  }

  static Future<String> _getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "aco-plus-fa455",
      "private_key_id": "a6ab67b221cc80a3bfbb16c51d41c210c6d4c9b0",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDIf9JvRUsd7EVR\nKPsCEapp62JuuM2nrbzgUHZo711xIdPLN29qPkrjY/9yCTXwanp7ecQVost1ZkuR\nia6zNgrBFGHuZaimxpMCJGS7ZAlIDN9qJmYTboFxmZE0pN9vK7jhMoSS9+0bo4yN\nHQpVlSU753pHWvPoN+ei3qiNkz+0/CNoRXLIWcDtTedqKR0hldpDx73pqcf918H8\nBvD/JYSTklHGjczS3Anjv/ujNmEgdxwb3mVc/y89iv5Di5p5nSMov+DT4RC/6wH/\n/ZlOmn6SuVJJKxYs2OASpaBNMo4fFstBXod1W9AeLBXWRPlmKM6e1QrjsUvjO3Vq\np3JFwgvnAgMBAAECggEAFqncL5e1lfxPGY14UhONH8vrpHhfRsTsxK5TtCjadx9L\nwXzSqz+/V1TGWy2PW02t6qco8wkj1nFpuVnG1ZsWPB0BtODo33EyzNswR75XDj3m\nQyl0AF5NY3noX/sDBp36l/oN4k8EDku+Z3UQ5ful6c+QkuBFEcq/9DkW9GngmaRz\nY8wFScBjCHO/tzNhSU2NtOwWbEmCnh5k5pqyLhQxcT5BFNoVYXYs92fDGzdeCFFR\nTqs4ITE8Fn4Lmmqre1/T4Hsoa1dmOstYIFtcJ1Mgn5idquJ1MTe32j+J/KBp0Ztt\nKNGVCCWtkHnkB70oN1NsOJ2qsZvm8is0v1dJdoIcgQKBgQDkU6KOc9DjaTxV2aa6\nL+QPdrltFElbZTEccRF4nKOuhtMy3g9+ia4Xpnbim3qp+uJignfdsLejkmHluSh5\nQO2QCBxhc+1YXgXiHwZM1uq/BFJfwUDWRvT6XaseoNgPxJGUboJbXD3X7qGvQA1W\npD+AChbsfvU7c9BdCXm2H6GxcwKBgQDgzMcSBdMRLzz3ebuYsQsfT8IsmsUXvI42\nyXPIzqiOiSnAzh7ZxkrAj4GvUgPT6Mhd0M/m5gMT+MV/pLXdAQDhE/R39ln0kwzV\nYjpSdPJgXFIH+UIpGfiYOxTmb7ns3e7dGshXcTanP1FLcAZthctTsbSa0xb/6hdd\nrrlRgytOvQKBgDD6J8J64XIGnuSjfXouz7LperkFQv8R48kAEAlZQFstnJwquhQg\noHF+Sb4uL8/Ke0k6R1AMmjfCLLHEWAQ6gzsEImJdJapw8L4ifY16BHzZBnp3z9qm\n+eHCufQl+HLZbYjzc475aGKrU49uI+5T6TMj9urgCOap3yY15B/HBT41AoGAZAFV\nciQbMKLmKWYDWbsxKn3N8Q/tLFEapy7ZjnS5Mae9ZmOL/++h46Yz2C3RPB1rvaie\nRKcAqYrbOZyptyayIG9DK3bxr8cXR3pKXdJe3RVU/O0bTLOcDwUBmD4N5V0Z3U0D\n4TqhSKf3X2r3wRNrT9FXeiT8L18RhACtuqByzLUCgYEA0MrtAYa3FlPu2XwXbg5X\n5KCWjzr0Qgcgep86nU/ABv8OFicGHZZY3mPfpDBjpD8gBCB6lGlHa6sAPJjqLsd5\nWKq8KwCdIcsmxrErbOdNAqSFhtgXZIM4zIvxSf0zzw4KK7VMIuVPM7f/QOo/Bfhg\nm5amPgT+O6A9rlM4ALuBTRI=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-ojuxq@aco-plus-fa455.iam.gserviceaccount.com",
      "client_id": "104857910631039811272",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ojuxq%40aco-plus-fa455.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }
}
