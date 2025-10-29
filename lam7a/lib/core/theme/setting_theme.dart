import 'package:flutter/material.dart';

final ThemeData xDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF000000),
  primaryColor: const Color(0xFF1D9BF0),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1D9BF0),
    secondary: Color(0xFF16181C),
    surface: Color(0xFF16181C),
    onPrimary: Colors.white,
    onSecondary: Color(0xFFE7E9EA),
    onSurface: Color(0xFFE7E9EA),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF000000),
    foregroundColor: Color(0xFFE7E9EA),
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE7E9EA)),
    bodyMedium: TextStyle(color: Color(0xFFE7E9EA)),
    bodySmall: TextStyle(color: Color(0xFF71767B)),
    titleMedium: TextStyle(
      color: Color.fromARGB(208, 220, 222, 223),
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    titleLarge: TextStyle(
      color: Color(0xFFE7E9EA),
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Color.fromARGB(255, 74, 76, 77),
    textColor: Color(0xFFE7E9EA),
    // overlayColor: Color.fromARGB(255, 83, 83, 84),
  ),
  dividerColor: const Color.fromARGB(105, 47, 51, 54),
  iconTheme: const IconThemeData(color: Color(0xFFE7E9EA)),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF16181C),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2F3336)),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    hintStyle: TextStyle(color: Color(0xFF71767B)),
  ),
);
