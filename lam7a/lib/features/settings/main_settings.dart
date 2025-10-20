import 'package:flutter/material.dart';
import './ui/view/main_settings_page.dart';
import 'package:lam7a/core/theme/setting_theme.dart';

void main() {
  runApp(const MainSettingsApp());
}

class MainSettingsApp extends StatelessWidget {
  const MainSettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Settings',
      theme: xDarkTheme,
      darkTheme: xDarkTheme,
      //debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false,
      home: const MainSettingsPage(),
    );
  }
}
