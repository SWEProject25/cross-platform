import 'package:flutter/material.dart';
import './ui/view/main_settings_page.dart';
import 'package:lam7a/core/theme/theme.dart';

void main() {
  runApp(const MainSettingsApp());
}

class MainSettingsApp extends StatelessWidget {
  const MainSettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Settings',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const MainSettingsPage(),
    );
  }
}
