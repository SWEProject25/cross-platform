import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/view/profile_summary_page.dart';



void main() {
  runApp(const ProviderScope(child: ProfileTestApp()));
}

class ProfileTestApp extends StatelessWidget {
  const ProfileTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Summary Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfileSummaryPage(),
      routes: {
        '/profile': (_) =>
            const Scaffold(body: Center(child: Text('Profile Page'))),
      },
    );
  }
}
