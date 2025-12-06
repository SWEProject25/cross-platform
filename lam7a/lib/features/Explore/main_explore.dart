import 'package:flutter/material.dart';
import './ui/view/explore_page.dart';
import 'package:lam7a/core/theme/setting_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() {
//   ProviderScope(child: const MainSettingsApp());
// }

void main() {
  runApp(const ProviderScope(child: MainExploreApp()));
}

class MainExploreApp extends StatelessWidget {
  const MainExploreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Explore',
      theme: xDarkTheme,
      darkTheme: xDarkTheme,
      //debugShowCheckedModeBanner: false,
      debugShowCheckedModeBanner: false,
      home: const ExplorePage(),
    );
  }
}
