import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_config.dart';
import '../shared/domain/entities/farm.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  static User? get currentUser => client.auth.currentUser;

  static bool get isAuthenticated => currentUser != null;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  static Future<Farm?> getFarmById(String farmId) async {
    try {
      final response =
          await client.from('farms').select('*').eq('id', farmId).maybeSingle();

      if (response == null) return null;
      return Farm.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get farm: $e');
    }
  }
}
