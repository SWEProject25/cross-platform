import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/profile_card.dart';

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

class ProfileSummaryList extends ConsumerWidget {
  const ProfileSummaryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(profileViewModelProvider);

    return profilesAsync.when(
      data: (profiles) => ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: profiles.length,
        separatorBuilder: (context, index) => const Divider(
          height: 0.5,
          thickness: 0.5,
          color: Color.fromRGBO(225, 225, 225, 1),
        ),
        itemBuilder: (context, index) {
          return ProfileCard(profile: profiles[index]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading profiles: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

