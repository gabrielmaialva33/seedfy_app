class AppConfig {
  static const String supabaseUrl = 'https://zyltwdnzyoagnhjdashj.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp5bHR3ZG56eW9hZ25oamRhc2hqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1ODcyMzcsImV4cCI6MjA3MjE2MzIzN30.NOEzoBeP1dZL89_BmSBA_U7uui479PaYsNAKug2sY94';
  
  // MongoDB Configuration
  static const String mongoDbUser = 'marlonbarreto2378_db_user';
  static const String mongoDbPassword = 'EGvzKaAwKUdEd0Q2';
  static const String mongoDbCluster = 'cluster0.eegt84g.mongodb.net';
  static const String mongoDbName = 'seedfyapp';
  
  static String get mongoConnectionString => 
      'mongodb+srv://$mongoDbUser:$mongoDbPassword@$mongoDbCluster/$mongoDbName?retryWrites=true&w=majority&appName=Cluster0';
  
  static const List<String> supportedLocales = ['pt', 'en'];
  static const String defaultLocale = 'pt';
  
  static const double defaultPathGap = 0.4; // metros
  static const double minBedSize = 0.5; // metros
  static const double maxBedSize = 5.0; // metros
}