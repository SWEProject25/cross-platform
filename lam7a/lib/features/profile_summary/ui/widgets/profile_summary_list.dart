import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/profile_viewmodel.dart';
import 'profile_card.dart';

class ProfileSummaryList extends ConsumerWidget {
  const ProfileSummaryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileViewModelProvider);

    return ListView.separated(
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
    );
  }
}
