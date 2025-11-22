// lib/features/profile/ui/view/followers_following_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import '../widgets/follow_button.dart';
import 'profile_screen.dart';

class FollowersFollowingPage extends ConsumerStatefulWidget {
  final int userId;
  final int initialTab; // 0 = followers, 1 = following

  const FollowersFollowingPage({super.key, required this.userId, this.initialTab = 0});

  @override
  ConsumerState<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends ConsumerState<FollowersFollowingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ProfileModel>? _followers;
  List<ProfileModel>? _following;
  bool _loadingFollowers = true;
  bool _loadingFollowing = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    _loadLists();
  }

  Future<void> _loadLists() async {
    final repo = ref.read(profileRepositoryProvider);
    try {
      final f = await repo.getFollowers(widget.userId);
      final g = await repo.getFollowing(widget.userId);
      if (mounted) {
        setState(() {
          _followers = f;
          _following = g;
          _loadingFollowers = false;
          _loadingFollowing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _followers = [];
          _following = [];
          _loadingFollowers = false;
          _loadingFollowing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTile(ProfileModel p) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(p.avatarImage), radius: 24),
      title: Row(children: [Text(p.displayName, style: const TextStyle(fontWeight: FontWeight.bold)), if (p.isVerified) const SizedBox(width: 6), if (p.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 16)]),
      subtitle: Text('@${p.handle}\n${p.bio}', maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: FollowButton(initialProfile: p),
      isThreeLine: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen(username: p.handle)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Followers'), Tab(text: 'Following')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loadingFollowers
              ? const Center(child: CircularProgressIndicator())
              : _followers == null || _followers!.isEmpty
                  ? const Center(child: Text('No followers yet'))
                  : ListView.separated(
                      itemCount: _followers!.length,
                      separatorBuilder: (_, __) => const Divider(height: 0.5),
                      itemBuilder: (_, i) => _buildTile(_followers![i]),
                    ),
          _loadingFollowing
              ? const Center(child: CircularProgressIndicator())
              : _following == null || _following!.isEmpty
                  ? const Center(child: Text('No following yet'))
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
