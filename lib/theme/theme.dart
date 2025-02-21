import 'package:flutter/material.dart';

class LightTheme {
  static const primaryColor = Color(0xFF3949AB);
  static const secondaryColor = Color(0xFF536DFE);

  static ThemeData get make => ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: secondaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(shape: LinearBorder.none),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey[300]),
    inputDecorationTheme: const InputDecorationTheme(errorMaxLines: 10),
  );
}

class DarkTheme {
  static const primaryColor = Color(0xFF536DFE);
  static const secondaryColor = Color(0xFF3D5AFE);

  static ThemeData get make => ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    cardTheme: CardTheme(
      color: Colors.grey[900],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1A237E)),
    inputDecorationTheme: const InputDecorationTheme(
      errorMaxLines: 10,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: secondaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(shape: LinearBorder.none),
    ),
    dividerTheme: DividerThemeData(color: Colors.grey[850]),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
  );
}
