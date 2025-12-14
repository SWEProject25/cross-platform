// feature/profile/ui/view/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';

import '../widgets/profile_header_widget.dart';
import '../widgets/profile_more_menu.dart';
import '../widgets/blocked_profile_view.dart';

import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final username = args?['username'] as String?;

    if (username == null || username.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No username provided")),
      );
    }

    final asyncUser = ref.watch(profileViewModelProvider(username));

    return asyncUser.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
      data: (user) => _ProfileLoaded(user: user, username: username),
    );
  }
}

class _ProfileLoaded extends ConsumerStatefulWidget {
  final UserModel user;
  final String username;

  const _ProfileLoaded({
    required this.user,
    required this.username,
  });

  @override
  ConsumerState<_ProfileLoaded> createState() => _ProfileLoadedState();
}

class _ProfileLoadedState extends ConsumerState<_ProfileLoaded> {
  final ScrollController _scrollController = ScrollController();
  bool _hideAvatar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldHide = _scrollController.offset > 60;
    if (shouldHide != _hideAvatar) {
      setState(() => _hideAvatar = shouldHide);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myUser = ref.watch(authenticationProvider).user;
    final isOwnProfile = myUser?.id == widget.user.profileId;

    Future<void> refresh() async {
      ref.invalidate(profileViewModelProvider(widget.username));
      ref.invalidate(profilePostsProvider(widget.user.profileId!.toString()));
      ref.invalidate(profileRepliesProvider(widget.user.profileId!.toString()));
      ref.invalidate(profileLikesProvider(widget.user.profileId!.toString()));
    }

    if (widget.user.stateBlocked == ProfileStateBlocked.blocked) {
      return BlockedProfileView(
        username: widget.username,
        userId: widget.user.profileId!,
        onUnblock: refresh,
      );
    }

    const double avatarRadius = 46;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: NestedScrollView(
          controller: _scrollController, // ✅ IMPORTANT
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (!isOwnProfile)
                  ProfileMoreMenu(
                    user: widget.user,
                    username: widget.username,
                    onAction: refresh,
                  ),
              ],
              flexibleSpace: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: (widget.user.bannerImageUrl != null &&
                            widget.user.bannerImageUrl!.isNotEmpty)
                        ? Image.network(
                            widget.user.bannerImageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey.shade300),
                  ),
                  Positioned(
                    bottom: -avatarRadius,
                    left: 16,
                    child: Offstage(
                      offstage: _hideAvatar, // ✅ avatar disappears
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: avatarRadius - 3,
                          backgroundImage:
                              (widget.user.profileImageUrl != null &&
                                      widget.user.profileImageUrl!.isNotEmpty)
                                  ? NetworkImage(
                                      widget.user.profileImageUrl!)
                                  : const AssetImage(
                                          "assets/images/user_profile.png")
                                      as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: ProfileHeaderWidget(
                user: widget.user,
                isOwnProfile: isOwnProfile,
                onEdited: refresh,
              ),
            ),
          ],
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Posts"),
                    Tab(text: "Replies"),
                    Tab(text: "Likes"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _ProfilePostsTab(
                          userId: widget.user.profileId!.toString()),
                      _ProfileRepliesTab(
                          userId: widget.user.profileId!.toString()),
                      _ProfileLikesTab(
                          userId: widget.user.profileId!.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- POSTS TAB ----------------
class _ProfilePostsTab extends ConsumerWidget {
  final String userId;
  const _ProfilePostsTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(profilePostsProvider(userId));

    return asyncPosts.when(
      data: (tweets) => tweets.isEmpty
          ? const Center(child: Text("No posts yet"))
          : ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (_, i) =>
                  TweetSummaryWidget(tweetData: tweets[i], tweetId: tweets[i].id),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading posts")),
    );
  }
}

// ---------------- REPLIES TAB ----------------
class _ProfileRepliesTab extends ConsumerWidget {
  final String userId;
  const _ProfileRepliesTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReplies = ref.watch(profileRepliesProvider(userId));

    return asyncReplies.when(
      data: (tweets) => tweets.isEmpty
          ? const Center(child: Text("No replies yet"))
          : ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (_, i) =>
                  TweetSummaryWidget(tweetData: tweets[i], tweetId: tweets[i].id),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading replies")),
    );
  }
}

// ---------------- LIKES TAB ----------------
class _ProfileLikesTab extends ConsumerWidget {
  final String userId;
  const _ProfileLikesTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLikes = ref.watch(profileLikesProvider(userId));

    return asyncLikes.when(
      data: (tweets) => tweets.isEmpty
          ? const Center(child: Text("No liked posts"))
          : ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (_, i) =>
                  TweetSummaryWidget(tweetData: tweets[i], tweetId: tweets[i].id),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading liked posts")),
    );
  }
}
