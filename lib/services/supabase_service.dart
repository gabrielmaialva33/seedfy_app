import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_config.dart';

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
  
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}