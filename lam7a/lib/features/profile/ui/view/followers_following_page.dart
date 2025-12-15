// lib/features/profile/ui/view/followers_following_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import '../widgets/follow_button.dart';

class FollowersFollowingPage extends ConsumerStatefulWidget {
  final int userId;
  final int initialTab; // 0 = followers, 1 = following

  const FollowersFollowingPage({
    super.key,
    required this.userId,
    this.initialTab = 0,
  });

  @override
  ConsumerState<FollowersFollowingPage> createState() =>
      _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends ConsumerState<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<UserModel>? _followers;
  List<UserModel>? _following;

  bool _loadingFollowers = true;
  bool _loadingFollowing = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(profileRepositoryProvider);

    try {
      final f = await repo.getFollowers(widget.userId);
      final g = await repo.getFollowing(widget.userId);

      if (!mounted) return;
      setState(() {
        _followers = f;
        _following = g;
        _loadingFollowers = false;
        _loadingFollowing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _followers = [];
        _following = [];
        _loadingFollowers = false;
        _loadingFollowing = false;
      });
    }
  }


Widget _buildTile(UserModel u) {
  final hasImage = u.profileImageUrl != null && u.profileImageUrl!.isNotEmpty;

  return InkWell(
    key: ValueKey('user_tile_${u.id}'),
    onTap: () async {
      final changed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: RouteSettings(arguments: {"username": u.username}),
        ),
      );

      if (changed == true) {
        setState(() {
          _followers?.removeWhere((e) => e.id == u.id);
          _following?.removeWhere((e) => e.id == u.id);
        });
        _hasChanges = true;
      }
      _hasChanges = true;
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            key: ValueKey('user_avatar_${u.id}'),
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: hasImage ? NetworkImage(u.profileImageUrl!) : null,
            child: !hasImage ? const Icon(Icons.person, color: Colors.white) : null,
          ),

          const SizedBox(width: 8), // <-- Reduce this to control spacing!

          // Username + Bio + Follow button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        u.name ?? "Unknown",
                        key: ValueKey('user_name_${u.id}'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // FollowButton(
                    //   key: ValueKey('follow_button_${u.id}'),
                    //   user: u,
                    //   onFollowStateChanged: () => _loadData(),
                    //   ),
                    FollowButton(
                      key: ValueKey('follow_button_${u.id}'),
                      user: u,
                      onFollowStateChanged: () {
                            setState(() {
                            _following?.removeWhere((e) => e.id == u.id);
                            _followers?.removeWhere((e) => e.id == u.id);
                          });
                        _hasChanges = true;
                        _loadData();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  "@${u.username ?? ''}${(u.bio != null && u.bio!.isNotEmpty) ? '\n${u.bio}' : ''}",
                  key: ValueKey('user_username_${u.id}'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      Navigator.pop(context, _hasChanges);
      return false; // prevent default pop
    },
    child: Scaffold(
      key: const ValueKey('followers_following_scaffold'),
      appBar: AppBar(
        key: const ValueKey('followers_following_appbar'),
        title: const Text('Connections'),
        bottom: TabBar(
          key: const ValueKey('followers_following_tabbar'),
          controller: _tabController,
          tabs: const [
            Tab(key: ValueKey('followers_tab'), text: 'Followers'),
            Tab(key: ValueKey('following_tab'), text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        key: const ValueKey('followers_following_tabview'),
        controller: _tabController,
        children: [
          _loadingFollowers
              ? const Center(key: ValueKey('followers_loading'), child: CircularProgressIndicator())
              : (_followers == null || _followers!.isEmpty)
                  ? const Center(key: ValueKey('followers_empty'), child: Text('No followers yet'))
                  : ListView.separated(
                      key: const ValueKey('followers_list'),
                      itemCount: _followers!.length,
                      separatorBuilder: (_, __) => const Divider(height: 0.5),
                      itemBuilder: (_, i) => _buildTile(_followers![i]),
                    ),
          _loadingFollowing
              ? const Center(key: ValueKey('following_loading'), child: CircularProgressIndicator())
              : (_following == null || _following!.isEmpty)
                  ? const Center(key: ValueKey('following_empty'), child: Text('Not following anyone'))
                  : ListView.separated(
                      key: const ValueKey('following_list'),
                      itemCount: _following!.length,
                      separatorBuilder: (_, __) => const Divider(height: 0.5),
                      itemBuilder: (_, i) => _buildTile(_following![i]),
                    ),
        ],
      ),
    )
    );
  }
}
