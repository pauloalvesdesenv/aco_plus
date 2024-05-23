import 'dart:developer';
import 'package:aco_plus/app/core/client/supabase/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  

class SupabaseService {
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
          url: SupabaseConstants.url, anonKey: SupabaseConstants.anon);
    } catch (_, __) {
      log(_.toString());
      log(__.toString());
    }
  }
}
