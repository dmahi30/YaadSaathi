import 'package:flutter/material.dart';

/// A deliberately strong black-on-white theme for the Display > High
/// Contrast setting. Kept self-contained (doesn't read from theme.dart)
/// so it can't accidentally break if theme.dart's internals change.
class AppHighContrastTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.black,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Color(0xFFB00020),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      dividerColor: Colors.black54,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }
}