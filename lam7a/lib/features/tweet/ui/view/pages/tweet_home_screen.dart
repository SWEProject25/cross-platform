import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

/// Home screen with FAB button to navigate to AddTweetScreen
class TweetHomeScreen extends ConsumerStatefulWidget {
  const TweetHomeScreen({super.key});

  @override
  ConsumerState<TweetHomeScreen> createState() => _TweetHomeScreenState();
}

class _TweetHomeScreenState extends ConsumerState<TweetHomeScreen>   with SingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _isTabBarVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("Current tab is: ${_tabController.index}");
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll events for pagination
  void _onScroll() {
    // Load more when scrolled to 80% of the list
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8;
    final TabController controller = DefaultTabController.of(context);
    if (currentScroll >= threshold) {
      final viewModel = ref.read(tweetHomeViewModelProvider.notifier);
      if (viewModel.hasMoreForYou && !viewModel.isLoadingMore && controller.index == 0) {
        viewModel.loadMoreTweets('for-you');
      }
      else if(viewModel.hasMoreFollowing && !viewModel.isLoadingMore && controller.index == 1)
      {
        viewModel.loadMoreTweets('following');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tweetsAsync = ref.watch(tweetHomeViewModelProvider);
    final viewModel = ref.read(tweetHomeViewModelProvider.notifier);

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
                    await viewModel.refreshTweets();
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

                      return TabBarView(
                        children: [
                          // For You tab
                          _buildTweetList(tweets['for-you']!, viewModel),
                          // Following tab (same for now, you can implement separate logic)
                          _buildTweetList(tweets['following']!, viewModel),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Error: $error"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.refreshTweets(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isTabBarVisible ? 1.0 : 0.0,
          child: FloatingActionButton(
            onPressed: () async {
              final authState = ref.read(authenticationProvider);

              if (!authState.isAuthenticated || authState.user == null) {
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
              
              // Refresh tweets after posting
              viewModel.refreshTweets();
            },
            backgroundColor: Pallete.borderHover,
            child: const Icon(Icons.add, color: Pallete.whiteColor),
          ),
        ),
      ),
    );
  }

  /// Build tweet list with pagination loading indicator
  Widget _buildTweetList(List<TweetModel> tweets, TweetHomeViewModel viewModel) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: tweets.length + (viewModel.hasMoreForYou ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end
        if (index == tweets.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return TweetSummaryWidget(
          tweetId: tweets[index].id,
          tweetData: tweets[index],
        );
      },
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 3,
      tabs: [
        Tab(
          child: Text(
            "For you",
            style: GoogleFonts.oxanium(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Following",
            style: GoogleFonts.oxanium(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
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