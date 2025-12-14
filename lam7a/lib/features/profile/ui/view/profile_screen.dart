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
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final username = args?['username'] as String?;

    if (username == null || username.isEmpty) {
      return const Scaffold(
        key: ValueKey('profile_no_username'),
        body: Center(child: Text("No username provided")),
      );
    }

    final asyncUser = ref.watch(profileViewModelProvider(username));

    return asyncUser.when(
      loading: () => const Scaffold(key: ValueKey('profile_loading'), body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(key: const ValueKey('profile_error'), body: Center(child: Text("Error: $err"))),
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
    final isOwnProfile = myUser?.id == user.profileId;

    /// Refresh function for pull-to-refresh
    Future<void> refresh() async {
      ref.invalidate(profileViewModelProvider(username));
      ref.invalidate(profilePostsProvider(user.profileId!.toString()));
      ref.invalidate(profileRepliesProvider(user.profileId!.toString()));
      ref.invalidate(profileLikesProvider(user.profileId!.toString()));
    }

    // Handle blocked profile state
    if (user.stateBlocked == ProfileStateBlocked.blocked) {
      return BlockedProfileView(
        username: username,
        userId: user.profileId!,
        onUnblock: () => refresh(),
      );
    }

    const double avatarRadius = 46;

    return Scaffold(
      key: const ValueKey('profile_loaded_scaffold'),
      body: RefreshIndicator(
        key: const ValueKey('profile_refresh_indicator'),
        onRefresh: refresh,
        child: NestedScrollView(
          key: const ValueKey('profile_nested_scroll'),
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              key: const ValueKey('profile_sliver_appbar'),
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.white,
              leading: IconButton(
                key: const ValueKey('profile_back_button'),
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              actions: [
                if (!isOwnProfile)
                  ProfileMoreMenu(
                    key: const ValueKey('profile_more_menu'),
                    user: user,
                    username: username,
                    onAction: () => refresh(),
                  ),
              ],

              flexibleSpace: LayoutBuilder(
                builder: (_, __) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: (user.bannerImageUrl != null && user.bannerImageUrl!.isNotEmpty)
                            ? Image.network(key: const ValueKey('profile_banner'), user.bannerImageUrl!, fit: BoxFit.cover)
                            : Container(color: Colors.grey.shade300),
                      ),
                      Positioned(
                        bottom: -avatarRadius,
                        left: 16,
                        child: CircleAvatar(
                          key: const ValueKey('profile_avatar_outer'),
                          radius: avatarRadius,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            key: const ValueKey('profile_avatar_inner'),
                            radius: avatarRadius - 3,
                            backgroundImage: (user.profileImageUrl != null &&
                                    user.profileImageUrl!.isNotEmpty)
                                ? NetworkImage(user.profileImageUrl!)
                                : const AssetImage("assets/images/user_profile.png")
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // SPACE BELOW AVATAR
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Profile Header (name, handle, bio...)
            SliverToBoxAdapter(
              key: const ValueKey('profile_header_section'),
              child: ProfileHeaderWidget(
                key: const ValueKey('profile_header_widget'),
                user: user,
                isOwnProfile: isOwnProfile,
                onEdited: () => refresh(),
              ),
            ),
          ],

          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  key: ValueKey('profile_tabbar'),
                  isScrollable: false,
                  tabs: [
                    Tab(key: ValueKey('profile_tab_posts'), text: "Posts"),
                    Tab(key: ValueKey('profile_tab_replies'), text: "Replies"),
                    Tab(key: ValueKey('profile_tab_likes'), text: "Likes"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    key: const ValueKey('profile_tabbar_view'),
                    children: [
                      _ProfilePostsTab(key: const ValueKey('profile_posts_tab'), userId: user.profileId!.toString(),),
                      _ProfileRepliesTab(key: const ValueKey('profile_replies_tab'), userId: user.profileId!.toString(),),
                      _ProfileLikesTab(key: const ValueKey('profile_likes_tab'), userId: user.profileId!.toString()),
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

// ----------------------- POSTS TAB -----------------------
class _ProfilePostsTab extends ConsumerWidget {
  final String userId;
  const _ProfilePostsTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(profilePostsProvider(userId));

    return asyncPosts.when(
      data: (tweets) {
        if (tweets.isEmpty) {
          return const Center(key: ValueKey('profile_posts_empty'), child: Text("No posts yet"));
        }
        return ListView.builder(
          key: const ValueKey('profile_posts_list'),
          physics: const AlwaysScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            key: ValueKey('profile_post_${tweets[i].id}'),
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(key: ValueKey('profile_posts_loading'), child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading posts")),
    );
  }
}

// ----------------------- REPLIES TAB -----------------------
class _ProfileRepliesTab extends ConsumerWidget {
  final String userId;
  const _ProfileRepliesTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReplies = ref.watch(profileRepliesProvider(userId));

    return asyncReplies.when(
      data: (tweets) {
        if (tweets.isEmpty) {
          return const Center(child: Text("No replies yet"));
        }
        return ListView.builder(
          key: ValueKey('profile_replies_list'),
          physics: const AlwaysScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            key: ValueKey('profile_reply_${tweets[i].id}'),
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(key: ValueKey('profile_replies_loading'), child: CircularProgressIndicator()),
      error: (_, __) => const Center(key: ValueKey('profile_replies_empty'), child: Text("Error loading replies")),
    );
  }
}

// ----------------------- LIKES TAB -----------------------
class _ProfileLikesTab extends ConsumerWidget {
  final String userId;
  const _ProfileLikesTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLikes = ref.watch(profileLikesProvider(userId));

    return asyncLikes.when(
      data: (tweets) {
        if (tweets.isEmpty) {
          return const Center(child: Text("No liked posts"));
        }
        return ListView.builder(
          key: ValueKey('profile_likes_list'),
          physics: const AlwaysScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            key: ValueKey('profile_like_${tweets[i].id}'),
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(key: ValueKey('profile_likes_loading'), child: CircularProgressIndicator()),
      error: (_, __) => const Center(key: ValueKey('profile_likes_empty'), child: Text("Error loading liked posts")),
    );
  }
}

