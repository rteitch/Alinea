import 'package:flutter/material.dart';

enum ReadingThemeMode {
  light,
  sepia,
  dark,
  amoled,
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2C5E8A),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F9FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E293B),
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get sepiaTheme {
    const sepiaBg = Color(0xFFF7F1E3);
    const sepiaSurface = Color(0xFFEFE8D6);
    const sepiaText = Color(0xFF4A3B32);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: sepiaBg,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8C5331),
        surface: sepiaSurface,
        onSurface: sepiaText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: sepiaSurface,
        foregroundColor: sepiaText,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A90E2),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121820),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1B232D),
        foregroundColor: Color(0xFFE2E8F0),
        elevation: 0,
      ),
    );
  }

  static ThemeData get amoledTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF64B5F6),
        surface: Color(0xFF0A0A0A),
        onSurface: Color(0xFFE0E0E0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Color(0xFFE0E0E0),
        elevation: 0,
      ),
    );
  }
}
