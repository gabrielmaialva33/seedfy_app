import 'package:flutter/material.dart';

class AppTheme {
  // 🌱 Paleta Seedfy - Inspirada na natureza e agricultura sustentável

  // Cores Principais
  static const seedfyGreen = Color(0xFF22C55E); // Verde vibrante principal
  static const earthGreen = Color(0xFF059669); // Verde terra mais escuro
  static const soilBrown = Color(0xFFA16207); // Marrom terra fértil
  static const sunGold = Color(0xFFEAB308); // Dourado do sol
  static const blossomPink = Color(0xFFEC4899); // Rosa floração

  // Sistema de Status (Semafórico para plantações)
  static const healthyGreen = Color(0xFF22C55E); // Saudável (>7 dias)
  static const warningYellow = Color(0xFFF59E0B); // Atenção (3-7 dias)
  static const criticalRed = Color(0xFFEF4444); // Crítico (<3 dias)
  static const emptyGray = Color(0xFF6B7280); // Canteiros vazios

  // Cores Complementares
  static const softGreen = Color(0xFFDCFCE7); // Background suave
  static const stoneGray = Color(0xFFF3F4F6); // Cards e neutrals
  static const darkText = Color(0xFF1F2937); // Textos principais
  static const lightText = Color(0xFF6B7280); // Textos secundários
  static const pureWhite = Color(0xFFFFFFFF); // Branco puro

  // Manter compatibilidade com código existente
  static const primaryPurple = seedfyGreen; // Compatibilidade
  static const primaryGreen = earthGreen; // Compatibilidade
  static const accentOrange = sunGold; // Compatibilidade
  static const backgroundLight = softGreen; // Compatibilidade
  static const cardWhite = pureWhite; // Compatibilidade
  static const textDark = darkText; // Compatibilidade
  static const textGray = lightText; // Compatibilidade
  static const successGreen = healthyGreen; // Compatibilidade
  static const errorRed = criticalRed; // Compatibilidade

  // Gradientes inspirados na natureza
  static const seedfyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [seedfyGreen, earthGreen],
  );

  static const sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [sunGold, soilBrown],
  );

  static const gardenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [softGreen, pureWhite],
  );

  static const earthGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [softGreen, stoneGray],
  );

  // Manter compatibilidade
  static const primaryGradient = seedfyGradient;
  static const cardGradient = gardenGradient;
  static const backgroundGradient = earthGradient;

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
        seedColor: seedfyGreen,
        brightness: Brightness.light,
        primary: seedfyGreen,
        secondary: earthGreen,
        tertiary: sunGold,
        surface: pureWhite,
        surfaceContainer: softGreen,
        onPrimary: pureWhite,
        onSecondary: pureWhite,
        onSurface: darkText,
        onSurfaceVariant: lightText,
      ),
      scaffoldBackgroundColor: softGreen,
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
          backgroundColor: seedfyGreen,
          foregroundColor: pureWhite,
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
        backgroundColor: seedfyGreen,
        foregroundColor: pureWhite,
      ),
    );
  }
}
