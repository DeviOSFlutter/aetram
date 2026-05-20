import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0D9488),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0D9488),
      secondary: Color(0xFF0F766E),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF0F172A),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFFF8FAFC),
      foregroundColor: Color(0xFF0F172A),
      shape: Border(
        bottom: BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: 0.8,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFFCCFBF1),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF14B8A6),
    scaffoldBackgroundColor: const Color(0xFF090D16),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF14B8A6),
      secondary: Color(0xFF2DD4BF),
      surface: Color(0xFF151F32),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF8FAFC),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF090D16),
      foregroundColor: Color(0xFFF8FAFC),
      shape: Border(
        bottom: BorderSide(
          color: Color(0xFF1E293B),
          width: 1,
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFFF8FAFC),
        letterSpacing: 0.8,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF111827),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFF1E293B),
          width: 1,
        ),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF0F172A),
      indicatorColor: Color(0xFF115E59),
    ),
  );
}