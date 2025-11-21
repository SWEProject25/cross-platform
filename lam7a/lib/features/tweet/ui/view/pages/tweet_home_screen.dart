import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweets_list_view.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';

/// Home screen with FAB button to navigate to AddTweetScreen
class TweetHomeScreen extends ConsumerStatefulWidget {
  const TweetHomeScreen({super.key});

  @override
  ConsumerState<TweetHomeScreen> createState() => _TweetHomeScreenState();
}

class _TweetHomeScreenState extends ConsumerState<TweetHomeScreen> {
  bool _isTabBarVisible = true;
  double _lastOffset = 0;

  @override
  Widget build(BuildContext context) {
    final tweetsAsync = ref.watch(tweetHomeViewModelProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            // Animated TabBar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isTabBarVisible ? 48 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isTabBarVisible ? 1.0 : 0.0,
                child: _buildTabBar(),
              ),
            ),

            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  _handleScrollNotification(notification);
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(tweetHomeViewModelProvider.notifier)
                        .refreshTweets();
                  },
                  child: tweetsAsync.when(
                    data: (tweets) {
                      if (tweets.isEmpty) {
                        return const Center(
                          child: Text(
                            'No tweets yet. Tap + to create your first tweet!',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      // Sort tweets newest first
                      final sortedTweets = tweets.toList()
                        ..sort((a, b) => b.date.compareTo(a.date));

                      return TabBarView(
                        children: [
                          TweetListView(tweets: sortedTweets),
                          TweetListView(tweets: sortedTweets),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text("Error: $error")),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Check authentication before navigating
            final authState = ref.read(authenticationProvider);

            if (!authState.isAuthenticated || authState.user == null) {
              // Show error if not authenticated
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in to post a tweet'),
                    backgroundColor: Pallete.errorColor,
                  ),
                );
              }
              return;
            }

            final userId = authState.user!.id ?? 1;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTweetScreen(userId: userId),
              ),
            );
            // Refresh tweets after returning from add screen
            ref.read(tweetHomeViewModelProvider.notifier).refreshTweets();
          },
          backgroundColor: Pallete.borderHover,
          child: const Icon(Icons.add, color: Pallete.whiteColor),
        ),
      ),
    );
  }

  TabBar _buildTabBar() {
    return const TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.blue,
      tabs: [
        Tab(text: "For You"),
        Tab(text: "Following"),
      ],
    );
  }

  Future<List<TweetModel>> _getTweets(WidgetRef ref) async {
    return await ref.watch(tweetHomeViewModelProvider.future);
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      if (notification is ScrollUpdateNotification) {
        final currentOffset = notification.metrics.pixels;

        if (currentOffset > _lastOffset + 10 && _isTabBarVisible) {
          setState(() => _isTabBarVisible = false);
        } else if (currentOffset < _lastOffset - 10 && !_isTabBarVisible) {
          setState(() => _isTabBarVisible = true);
        }

        _lastOffset = currentOffset;
      }
    }
  }
}
