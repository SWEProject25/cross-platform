import 'package:flutter/material.dart';
import './ui/view/main_settings_page.dart';
import 'package:lam7a/core/theme/setting_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() {
//   ProviderScope(child: const MainSettingsApp());
// }

void main() {
  runApp(const ProviderScope(child: MainSettingsApp()));
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
