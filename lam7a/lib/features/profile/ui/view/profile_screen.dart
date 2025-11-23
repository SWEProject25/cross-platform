// lib/features/profile/ui/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import '../widgets/profile_header_widget.dart';

class ProfileScreen extends ConsumerWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileViewModelProvider(username));

    return asyncProfile.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
      data: (profile) => _ProfileLoaded(profile: profile, username: username),
    );
  }
}

class _ProfileLoaded extends ConsumerWidget {
  final ProfileModel profile;
  final String username;

  const _ProfileLoaded({
    required this.profile,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(authenticationProvider).user;
    final bool isOwnProfile = myUser?.id == profile.userId;

    void refresh() => ref.invalidate(profileViewModelProvider(username));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          /// EMPTY APPBAR: Banner moved to ProfileHeaderWidget
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],

        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            ProfileHeaderWidget(
              profile: profile,
              isOwnProfile: isOwnProfile,
              onEdited: refresh,
            ),

            const SizedBox(height: 16),

            /// Tabs
            DefaultTabController(
              length: 6,
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: "Posts"),
                      Tab(text: "Replies"),
                      Tab(text: "Highlights"),
                      Tab(text: "Articles"),
                      Tab(text: "Media"),
                      Tab(text: "Likes"),
                    ],
                  ),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      children: List.generate(
                        6,
                        (index) => ListView.builder(
                          itemCount: 10,
                          itemBuilder: (_, i) => ListTile(
                            title: Text("Item $i"),
                            subtitle: const Text("Content coming later"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
