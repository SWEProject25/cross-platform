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
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: hasImage ? NetworkImage(u.profileImageUrl!) : null,
        child: !hasImage ? const Icon(Icons.person, color: Colors.white) : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(u.name ?? "Unknown",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Follow button
          FollowButton(user: u),
        ],
      ),
      subtitle: Text(
        "@${u.username ?? ''}${(u.bio != null && u.bio!.isNotEmpty) ? '\n${u.bio}' : ''}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      onTap: () {
        // navigate to profile and pass username as argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
            settings: RouteSettings(arguments: {"username": u.username}),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Followers'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loadingFollowers
              ? const Center(child: CircularProgressIndicator())
              : (_followers == null || _followers!.isEmpty)
                  ? const Center(child: Text('No followers yet'))
                  : ListView.separated(
                      itemCount: _followers!.length,
                      separatorBuilder: (_, __) => const Divider(height: 0.5),
                      itemBuilder: (_, i) => _buildTile(_followers![i]),
                    ),
          _loadingFollowing
              ? const Center(child: CircularProgressIndicator())
              : (_following == null || _following!.isEmpty)
                  ? const Center(child: Text('Not following anyone'))
                  : ListView.separated(
                      itemCount: _following!.length,
                      separatorBuilder: (_, __) => const Divider(height: 0.5),
                      itemBuilder: (_, i) => _buildTile(_following![i]),
                    ),
        ],
      ),
    );
  }
}
