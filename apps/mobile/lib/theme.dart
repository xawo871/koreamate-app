import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF5B5BD6);
  static const Color primarySoft = Color(0xFFEEF0FF);
  static const Color background = Color(0xFFF6F7FB);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);
  static const Color accent = Color(0xFF34D399);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: text,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
