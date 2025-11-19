// lib/ui/view/followers_following_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/profile_card.dart';
import '../../model/profile_model.dart';
import '../viewmodel/profile_viewmodel.dart';

class FollowersFollowingPage extends ConsumerStatefulWidget {
  final String username;

  const FollowersFollowingPage({super.key, required this.username});

  @override
  ConsumerState<FollowersFollowingPage> createState() =>
      _FollowersFollowingPageState();
}

class _FollowersFollowingPageState
    extends ConsumerState<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileListViewModelProvider);
    final profileState = ref.watch(profileListStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          widget.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
          ),
        ),
      ),
      body: profileAsync.when(
        data: (profiles) {
          // Initialize state if not set
          if (profileState == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(profileListStateProvider.notifier).state = profiles;
            });
          }

          final effectiveProfiles = profileState ?? profiles;
          
          final followers = effectiveProfiles
              .where((p) => p.stateFollow == ProfileStateOfFollow.notfollowing)
              .toList();
          final following = effectiveProfiles
              .where((p) => p.stateFollow == ProfileStateOfFollow.following)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              ListView.separated(
                itemCount: followers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 0.5),
                itemBuilder: (_, index) => ProfileCard(profile: followers[index]),
              ),
              ListView.separated(
                itemCount: following.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 0.5),
                itemBuilder: (_, index) => ProfileCard(profile: following[index]),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
