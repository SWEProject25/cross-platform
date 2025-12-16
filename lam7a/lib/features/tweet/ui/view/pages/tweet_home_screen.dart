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

  class _TweetHomeScreenState extends ConsumerState<TweetHomeScreen>
      with SingleTickerProviderStateMixin {
    static const double _tabBarHeight = 50;
    final ScrollController _scrollController = ScrollController();
    late TabController _tabController;
    bool _isTabBarVisible = true;
    double _lastOffset = 0;
    bool _isLoadingMore = false; // Add flag to prevent multiple loads

    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: 2, vsync: this);
      _tabController.addListener(() async {
        print("Current tab is: ${_tabController.index}");
        final viewmodel = ref.read(tweetHomeViewModelProvider.notifier);
        if (_tabController.index == 1 && viewmodel.isFollowingEmptyInState()) {
          await viewmodel.refreshFollowingTweets();
        }
      });
      _scrollController.addListener(_onScroll);
    }

    @override
    void dispose() {
      _scrollController.removeListener(_onScroll);
      _scrollController.dispose();
      _tabController.dispose();
      super.dispose();
    }

    // @override
    // void didChangeDependencies() {
    //   super.didChangeDependencies();

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (!mounted) return;
    //     if (!_isTabBarVisible) {
    //       setState(() {
    //         _isTabBarVisible = true;
    //         _lastOffset = 0;
    //       });
    //     }
    //   });
    // }

    /// Handle scroll events for pagination
    void _onScroll() async {
      if (_isLoadingMore) return; // Prevent multiple simultaneous loads

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = maxScroll * 0.7;
      final viewModel = ref.read(tweetHomeViewModelProvider.notifier);

      if (currentScroll >= threshold) {
        if (_tabController.index == 0 &&
            viewModel.hasMoreForYou &&
            !viewModel.isLoadingMore) {
          await _loadMoreForYou(viewModel);
        } else if (_tabController.index == 1 &&
            viewModel.hasMoreFollowing &&
            !viewModel.isLoadingMore) {
          await _loadMoreFollowing(viewModel);
        }
      }
    }

    /// Load more tweets with proper async handling
    Future<void> _loadMoreForYou(TweetHomeViewModel viewModel) async {
      if (_isLoadingMore) return;

      setState(() => _isLoadingMore = true);
      try {
        await viewModel.loadMoreTweetsForYou().timeout(
          const Duration(seconds: 4),
        );
        setState(() => _isLoadingMore = false);
      } finally {
        if (mounted) {
          setState(() => _isLoadingMore = false);
        }
      }
    }

    Future<void> _loadMoreFollowing(TweetHomeViewModel viewModel) async {
      if (_isLoadingMore) return;

      setState(() => _isLoadingMore = true);
      try {
        await viewModel.loadMoreTweetsFollowing().timeout(
          const Duration(seconds: 4),
        );
        setState(() => _isLoadingMore = false);
      } finally {
        if (mounted) {
          setState(() => _isLoadingMore = false);
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
              PreferredSize(
                preferredSize: Size.fromHeight(_tabBarHeight),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isTabBarVisible ? _tabBarHeight : 0.00,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isTabBarVisible ? 1.00 : 0.00,
                    child: _buildTabBar(),
                  ),
                ),
              ),

              Expanded(
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

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.metrics.axis != Axis.vertical) {
                          return false;
                        }
                        if (scroll is ScrollUpdateNotification) {
                          final currentOffset = scroll.metrics.pixels;

                          // Scroll down - hide both bars
                          if (currentOffset > _lastOffset + 10 &&
                              _isTabBarVisible) {
                            setState(() {
                              _isTabBarVisible = false;
                            });
                          }
                          // Scroll up - show both bars
                          else if (currentOffset < _lastOffset - 3 &&
                              !_isTabBarVisible) {
                            setState(() {
                              _isTabBarVisible = true;
                            });
                          }

                          _lastOffset = currentOffset;
                        }
                        return false;
                      },
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // For You tab
                          RefreshIndicator(
                            onRefresh: () async {
                              await viewModel.refreshTweetsForYou();
                            },
                            child: _buildTweetList(
                              tweets['for-you']!,
                              viewModel.hasMoreForYou,
                            ),
                          ),
                          // Following tab
                          RefreshIndicator(
                            onRefresh: () async {
                              await viewModel.refreshFollowingTweets();
                            },
                            child: _buildTweetList(
                              tweets['following']!,
                              viewModel.hasMoreFollowing,
                            ),
                            
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Error: $error"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_tabController.index == 0) {
                              await viewModel.refreshTweetsForYou();
                            } else {
                              await viewModel.refreshFollowingTweets();
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isTabBarVisible ? 70 : 0.0,
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

                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              backgroundColor: Pallete.borderHover,
              child: Icon(
                Icons.add,
                color: Pallete.whiteColor,
                size: _isTabBarVisible ? 20 : 0.00,
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildTweetList(List<TweetModel> tweets, bool hasMore) {
      if (tweets.isEmpty && !hasMore) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Text(
                    "There's no tweets press + to add more",
                    style: GoogleFonts.oxanium(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
      return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tweets.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == tweets.length && hasMore) {
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
        controller: _tabController,
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
  }
