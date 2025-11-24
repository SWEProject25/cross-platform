import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/ui/widgets/profile_header_widget.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';

/// Testing entry point for profile header
class ProfileHeaderMain extends ConsumerWidget {
  const ProfileHeaderMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load profile using viewmodel
    final asyncProfile = ref.watch(profileViewModelProvider("hossam_dev"));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Header Demo'),
        centerTitle: true,
      ),
      body: asyncProfile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (profile) => ProfileHeaderWidget(
          profile: profile,
          isOwnProfile: true, // set false to test other users
        ),
      ),
    );
  }
}

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
