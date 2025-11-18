// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/widgets/profile_header_widget.dart';

/// Entry point widget to test the profile header UI
class ProfileHeaderMain extends StatelessWidget {
  const ProfileHeaderMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Header Demo'),
        centerTitle: true,
      ),
    
      body: const ProfileHeaderWidget(
        userId: 'hossam_dev',
        isOwnProfile: true, // Change to false to see other user's profile
      ),
    );
  }
}

/// App entry point
void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProfileHeaderMain(),
      ),
    ),
  );
}