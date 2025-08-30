import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale(AppConfig.defaultLocale);
  
  Locale get locale => _locale;
  
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? AppConfig.defaultLocale;
    _locale = Locale(localeCode);
    notifyListeners();
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }
  
  bool isPortuguese() => _locale.languageCode == 'pt';
}