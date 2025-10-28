import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/viewmodel/profile_header_viewmodel.dart';
import 'ui/widgets/profile_header_widget.dart';
import '../profile_edit/ui/view/edit_profile_page.dart'; 

/// Entry point widget to test the profile header UI
class ProfileHeaderMain extends ConsumerStatefulWidget {
  const ProfileHeaderMain({super.key});

  @override
  ConsumerState<ProfileHeaderMain> createState() => _ProfileHeaderMainState();
}

class _ProfileHeaderMainState extends ConsumerState<ProfileHeaderMain> {
  @override
  void initState() {
    super.initState();

    // Load mock profile automatically when the widget starts
    Future.microtask(() {
      ref
          .read(profileHeaderViewModelProvider.notifier)
          .loadProfileHeader('hossam_dev'); // ✅ match mock data username
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileHeaderViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Header Demo'),
        centerTitle: true,
      ),
      body: profileState.when(
        data: (profile) => ProfileHeaderWidget(
          profile: profile,
          onEditPressed: () {
            // ✅ Navigate to Edit Profile Page when button pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfilePage(profile: profile),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('❌ Error loading profile: $error'),
        ),
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
