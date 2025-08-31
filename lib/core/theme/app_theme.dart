import 'package:flutter/material.dart';

class AppTheme {
  // Cores inspiradas no Nubank + Instagram + iFood
  static const primaryPurple = Color(0xFF8B5CF6);
  static const primaryGreen = Color(0xFF10B981);
  static const accentOrange = Color(0xFFFF6B35);
  static const backgroundLight = Color(0xFFFAFAFA);
  static const cardWhite = Colors.white;
  static const textDark = Color(0xFF1A1A1A);
  static const textGray = Color(0xFF6B7280);
  static const successGreen = Color(0xFF22C55E);
  static const warningYellow = Color(0xFFFBBF24);
  static const errorRed = Color(0xFFEF4444);

  // Gradientes modernos
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryGreen],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
  );

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLight, Color(0xFFF1F5F9)],
  );

  // Sombras modernas (estilo Nubank)
  static const cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const elevatedShadow = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 15,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 30,
      offset: Offset(0, 12),
    ),
  ];

  // Border Radius moderno
  static const cardRadius = BorderRadius.all(Radius.circular(16));
  static const buttonRadius = BorderRadius.all(Radius.circular(12));
  static const imageRadius = BorderRadius.all(Radius.circular(20));

  // Tipografia moderna
  static const headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: textDark,
    fontSize: 24,
    height: 1.2,
  );

  static const titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: textDark,
    fontSize: 18,
    height: 1.3,
  );

  static const bodyStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: textDark,
    fontSize: 16,
    height: 1.5,
  );

  static const captionStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: textGray,
    fontSize: 14,
    height: 1.4,
  );

  static const smallStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: textGray,
    fontSize: 12,
    height: 1.3,
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      // Fonte moderna
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
        secondary: primaryGreen,
        surface: cardWhite,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        titleTextStyle: titleStyle,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardWhite,
        shape: const RoundedRectangleBorder(borderRadius: cardRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 8,
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
