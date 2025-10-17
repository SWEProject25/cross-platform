import 'package:flutter/material.dart';

//TODO: Adjust Later
class AppTheme {
  // 🎨 Base color palette
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _foreground = Color(0xFF0F1419);
  static const Color _primary = Color(0xFF1D9BF0);
  static const Color _primaryHover = Color(0xFF1A8CD8);
  static const Color _secondary = Color(0xFF536471);
  static const Color _accent = Color(0xFFF91880);
  static const Color _success = Color(0xFF00BA7C);
  static const Color _warning = Color(0xFFFFD400);

  // 🌞 Light theme
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _background,
    primaryColor: _primary,
    colorScheme: const ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
      surface: _background,
      error: _accent,
      onPrimary: Colors.white,
      onSecondary: _foreground,
      onSurface: _foreground,
      onError: Colors.white,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      foregroundColor: _foreground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: _foreground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _foreground),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _foreground),
      bodyLarge: TextStyle(fontSize: 16, color: _foreground),
      bodyMedium: TextStyle(fontSize: 14, color: _secondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _primary),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _foreground,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    ),

    // Floating Action Button (like tweet button)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),

    // TextFields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      hintStyle: const TextStyle(color: _secondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE1E8ED),
      thickness: 0.8,
    ),

    // Icon
    iconTheme: const IconThemeData(color: _secondary),
  );

  // 🌚 Dark theme
  static ThemeData get dark => light.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF000000),
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: Color(0xFF8B98A5),
      surface: Color(0xFF000000),
      error: _accent,
      onPrimary: Colors.white,
      onSecondary: Colors.white70,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: light.appBarTheme.copyWith(
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      titleTextStyle: light.appBarTheme.titleTextStyle?.copyWith(color: Colors.white),
    ),
    textTheme: light.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
    inputDecorationTheme: light.inputDecorationTheme.copyWith(
      fillColor: const Color(0xFF16181C),
      hintStyle: const TextStyle(color: Color(0xFF8B98A5)),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _background,
        foregroundColor: _foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF2F3336)),
    iconTheme: const IconThemeData(color: Color(0xFF8B98A5)),
  );

  // 🪄 Custom color extensions
  static ThemeData withPrimary(Color newPrimary) => light.copyWith(
        colorScheme: light.colorScheme.copyWith(primary: newPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: newPrimary),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: newPrimary),
      );
}
