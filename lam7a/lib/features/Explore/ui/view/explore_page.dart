import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../viewmodel/explore_viewmodel.dart';

import 'explore_and_trending/for_you_view.dart';
import 'explore_and_trending/trending_view.dart';

import '../../../common/widgets/tweets_list.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});
  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final tabs = ["For You", "Trending", "News", "Sports", "Entertainment"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final vm = ref.read(exploreViewModelProvider.notifier);
      vm.selectTab(ExplorePageView.values[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreViewModelProvider);
    final vm = ref.read(exploreViewModelProvider.notifier);

    final width = MediaQuery.of(context).size.width;

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text("Error: $e"),
      data: (data) {
        final index = ExplorePageView.values.indexOf(data.selectedPage);

        // Sync TabBar with state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tabController.index != index &&
              !_tabController.indexIsChanging) {
            _tabController.animateTo(index);
          }
        });

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              _buildTabBar(width),

              const Divider(color: Colors.white12, height: 1),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _forYouTab(data, vm),
                    _trendingTab(data, vm),
                    _newsTab(data, vm),
                    _sportsTab(data, vm),
                    _entertainmentTab(data, vm),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(double width) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.zero,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,

        // INDICATOR
        indicatorColor: const Color(0xFF1d9bf0),
        indicatorWeight: 3,

        labelPadding: const EdgeInsets.only(right: 28),

        // TEXT COLORS
        labelColor: theme.brightness == Brightness.light
            ? const Color(0xFF0f1418)
            : const Color(0xFFd9d9d9),
        unselectedLabelColor: theme.brightness == Brightness.light
            ? const Color(0xFF526470)
            : const Color(0xFF7c838b),

        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),

        dividerColor: theme.brightness == Brightness.light
            ? const Color(0xFFE5E5E5)
            : const Color(0xFF2A2A2A),
        dividerHeight: 0.3,

        tabs: const [
          Tab(text: "For You"),
          Tab(text: "Trending"),
          Tab(text: "News"),
          Tab(text: "Sports"),
          Tab(text: "Entertainment"),
        ],
      ),
    );
  }
}

Widget _forYouTab(ExploreState data, ExploreViewModel vm) {
  print("For You Tab rebuilt");
  if (data.isForYouTweetsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.forYouTweets.isEmpty) {
    return const Center(
      child: Text(
        "No tweets found for you",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  return TweetsListView(
    tweets: data.forYouTweets,
    hasMore: data.hasMoreForYouTweets,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreForYou(),
  );
}

Widget _trendingTab(ExploreState data, ExploreViewModel vm) {
  print("Trending Tab rebuilt");
  if (data.isHashtagsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.trendingHashtags.isEmpty) {
    return const Center(
      child: Text(
        "No trending hashtags found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  return TrendingView(trendingHashtags: data.trendingHashtags);
}

Widget _newsTab(ExploreState data, ExploreViewModel vm) {
  print("News Tab rebuilt");
  if (data.isNewsTweetsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.newsTweets.isEmpty) {
    return const Center(
      child: Text(
        "No news tweets found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  return TweetsListView(
    tweets: data.newsTweets,
    hasMore: data.hasMoreNewsTweets,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreNews(),
  );
}

Widget _sportsTab(ExploreState data, ExploreViewModel vm) {
  print("Sports Tab rebuilt");
  if (data.isSportsTweetsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.sportsTweets.isEmpty) {
    return const Center(
      child: Text(
        "No sports tweets found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  return TweetsListView(
    tweets: data.sportsTweets,
    hasMore: data.hasMoreSportsTweets,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreSports(),
  );
}

Widget _entertainmentTab(ExploreState data, ExploreViewModel vm) {
  print("Entertainment Tab rebuilt");
  if (data.isEntertainmentTweetsLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.entertainmentTweets.isEmpty) {
    return const Center(
      child: Text(
        "No entertainment tweets found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
  return TweetsListView(
    tweets: data.entertainmentTweets,
    hasMore: data.hasMoreEntertainmentTweets,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreEntertainment(),
  );
}
