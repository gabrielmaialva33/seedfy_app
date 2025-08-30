class AppConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static const List<String> supportedLocales = ['pt', 'en'];
  static const String defaultLocale = 'pt';
  
  static const double defaultPathGap = 0.4; // metros
  static const double minBedSize = 0.5; // metros
  static const double maxBedSize = 5.0; // metros
}