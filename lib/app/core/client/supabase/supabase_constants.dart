import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = SupabaseClient(
    SupabaseConstants.url, SupabaseConstants.anon,
    storageOptions: const StorageClientOptions(retryAttempts: 3),
    authOptions: AuthClientOptions(
        autoRefreshToken: true,
        authFlowType: AuthFlowType.pkce,
        pkceAsyncStorage: SharedPreferencesGotrueAsyncStorage()));

class SupabaseConstants {
  static const String url = 'https://zfbiwirqqswzrifkuomy.supabase.co';
  static const String anon =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmYml3aXJxcXN3enJpZmt1b215Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0MjMwNTUsImV4cCI6MjAzMTk5OTA1NX0.8MCGImwviMau90FhJYFJhPnQAkTPW7ofORqj0EGDq4w';
}
