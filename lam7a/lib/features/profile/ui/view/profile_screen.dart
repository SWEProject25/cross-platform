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
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text("Error: $err"))),
      data: (profile) => _ProfileLoaded(profile: profile),
    );
  }
}

class _ProfileLoaded extends ConsumerWidget {
  final ProfileModel profile;

  const _ProfileLoaded({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIX: Determine ownership from auth provider
    final myUser = ref.watch(authenticationProvider).user;
    final isOwnProfile = myUser != null && myUser.id == profile.userId;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 260,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (!isOwnProfile)
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => _openNotificationSettings(context),
                  ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _openOverflowMenu(context),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: ProfileHeaderWidget(
                  profile: profile,
                  isOwnProfile: isOwnProfile,
                ),
              ),
            ),
          ];
        },
        body: _buildTabView(),
      ),
    );
  }

  Widget _buildTabView() {
    return DefaultTabController(
      length: 6,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Posts"),
              Tab(text: "Replies"),
              Tab(text: "Highlights"),
              Tab(text: "Articles"),
              Tab(text: "Media"),
              Tab(text: "Likes"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _fakeList("Posts"),
                _fakeList("Replies"),
                _fakeList("Highlights"),
                _fakeList("Articles"),
                _fakeList("Media"),
                _fakeList("Likes"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fakeList(String title) => ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => ListTile(
          title: Text("$title item $i"),
          subtitle: const Text("This will later show real tweets."),
        ),
      );

  void _openOverflowMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem("Share"),
            _menuItem("Turn off reposts"),
            _menuItem("Add/remove from Lists"),
            _menuItem("View Lists"),
            _menuItem("Lists they're on"),
            _menuItem("Mute"),
            _menuItem("Block"),
            _menuItem("Report"),
          ],
        );
      },
    );
  }

  Widget _menuItem(String title) => ListTile(title: Text(title), onTap: () {});

  void _openNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Don't miss a thing", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("@${profile.handle}", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              _radioTile("All Posts"),
              _radioTile("All Posts & Replies"),
              _radioTile("Only live video"),
              _radioTile("Off", selected: true),
            ],
          ),
        );
      },
    );
  }

  Widget _radioTile(String text, {bool selected = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
      title: Text(text),
      onTap: () {},
    );
  }
}
