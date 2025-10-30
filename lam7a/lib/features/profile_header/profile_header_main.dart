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
        title: Text('Profile Header Demo'),
        centerTitle: true,
      ),
      // Just render the ProfileHeaderWidget and pass the user ID
      body: ProfileHeaderWidget(userId: 'hossam_dev'),
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
