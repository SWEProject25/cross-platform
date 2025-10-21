import 'package:flutter/material.dart';
import '../widgets/profile_summary_list.dart';

class ProfileSummaryPage extends StatelessWidget {
  const ProfileSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profiles')),
      body: const ProfileSummaryList(),
    );
  }
}
