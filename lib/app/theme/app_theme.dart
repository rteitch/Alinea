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
    const primary = Color(0xFF2C5E8A);
    const surface = Color(0xFFFFFFFF);
    const onSurface = Color(0xFF1E293B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF9F9FB),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return onSurface;
          }),
        ),
      ),
    );
  }

  static ThemeData get sepiaTheme {
    const sepiaBg = Color(0xFFF7F1E3);
    const sepiaSurface = Color(0xFFEFE8D6);
    const sepiaSurfaceVariant = Color(0xFFE5DCB9);
    const sepiaText = Color(0xFF4A3B32);
    const sepiaPrimary = Color(0xFF8C5331);
    const sepiaPrimaryContainer = Color(0xFFDECFB8);
    const sepiaOnPrimaryContainer = Color(0xFF3E200C);
    const sepiaSecondary = Color(0xFF7D583F);
    const sepiaSecondaryContainer = Color(0xFFE8DAC8);
    const sepiaOnSecondaryContainer = Color(0xFF332014);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: sepiaBg,
      colorScheme: const ColorScheme.light(
        primary: sepiaPrimary,
        onPrimary: Colors.white,
        primaryContainer: sepiaPrimaryContainer,
        onPrimaryContainer: sepiaOnPrimaryContainer,
        secondary: sepiaSecondary,
        onSecondary: Colors.white,
        secondaryContainer: sepiaSecondaryContainer,
        onSecondaryContainer: sepiaOnSecondaryContainer,
        surface: sepiaSurface,
        onSurface: sepiaText,
        surfaceContainerHighest: sepiaSurfaceVariant,
        outline: Color(0xFFC7B89E),
        outlineVariant: Color(0xFFDDD2BC),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: sepiaSurface,
        foregroundColor: sepiaText,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: sepiaBg,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: sepiaSurface,
        surfaceTintColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return sepiaPrimary;
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return sepiaText;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: Color(0xFFC7B89E)),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const primary = Color(0xFF4A90E2);
    const bg = Color(0xFF121820);
    const surface = Color(0xFF1B232D);
    const onSurface = Color(0xFFE2E8F0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return onSurface;
          }),
        ),
      ),
    );
  }

  static ThemeData get amoledTheme {
    const primary = Color(0xFF64B5F6);
    const surface = Color(0xFF0D0D0D);
    const onSurface = Color(0xFFE0E0E0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.black,
        primaryContainer: Color(0xFF152A3E),
        onPrimaryContainer: Color(0xFFE1F5FE),
        secondaryContainer: Color(0xFF1E1E1E),
        onSecondaryContainer: Color(0xFFE0E0E0),
        surface: surface,
        onSurface: onSurface,
        outline: Color(0xFF333333),
        outlineVariant: Color(0xFF222222),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: onSurface,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) return Colors.black;
            return onSurface;
          }),
        ),
      ),
    );
  }
}
