// lib/features/profile/ui/view/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/core/providers/authentication.dart';

import '../widgets/profile_header_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final username = args?['username'] as String?;
    if (username == null || username.isEmpty) {
      return const Scaffold(body: Center(child: Text('No username provided')));
    }

    final asyncUser = ref.watch(profileViewModelProvider(username));

    return asyncUser.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (user) => _ProfileLoaded(user: user, username: username),
    );
  }
}

class _ProfileLoaded extends ConsumerWidget {
  final UserModel user;
  final String username;

  const _ProfileLoaded({required this.user, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(authenticationProvider).user;
    final isOwnProfile = myUser?.id == user.id;

    void refresh() => ref.invalidate(profileViewModelProvider(username));
    const double avatarRadius = 46.0;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // SliverAppBar with banner and avatar overlay
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            backgroundColor: Colors.white,
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              return Stack(clipBehavior: Clip.none, children: [
                // banner fills the expanded area
                Positioned.fill(
                  child: user.bannerImageUrl != null && user.bannerImageUrl!.isNotEmpty
                      ? Image.network(user.bannerImageUrl!, fit: BoxFit.cover)
                      : Container(color: Colors.grey.shade300),
                ),

                // avatar overlaps bottom of banner
                Positioned(
                  bottom: -avatarRadius,
                  left: 16,
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: avatarRadius - 3,
                      backgroundImage: (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                          ? NetworkImage(user.profileImageUrl!)
                          : const AssetImage('assets/images/user_profile.png') as ImageProvider,
                    ),
                  ),
                ),
              ]);
            }),
          ),

          // spacer so content below doesn't overlap avatar
          SliverToBoxAdapter(child: SizedBox(height: avatarRadius + 12)),

          // header content (name, bio, buttons...) placed in ProfileHeaderWidget
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(user: user, isOwnProfile: isOwnProfile, onEdited: refresh),
          ),
        ],

        body: DefaultTabController(
          length: 6,
          child: Column(children: [
            const TabBar(isScrollable: true, tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Replies'),
              Tab(text: 'Highlights'),
              Tab(text: 'Articles'),
              Tab(text: 'Media'),
              Tab(text: 'Likes'),
            ]),
            Expanded(
              child: TabBarView(
                children: List.generate(
                  6,
                  (i) => ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, idx) => ListTile(title: Text('Item $idx'), subtitle: const Text('Content coming later')),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
