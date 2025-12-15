import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../viewmodel/explore_viewmodel.dart';

import 'explore_and_trending/for_you_view.dart';
import 'explore_and_trending/trending_view.dart';

import '../widgets/hashtag_list_item.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  static const Key tabBarKey = Key('explore_tab_bar');
  static const Key tabBarViewKey = Key('explore_tab_bar_view');
  static const Key scaffoldKey = Key('explore_scaffold');

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
    final theme = Theme.of(context);

    return state.when(
      loading: () => Center(
        child: CircularProgressIndicator(
          key: Key('explore_loading'),
          color: theme.brightness == Brightness.light
              ? const Color(0xFF1D9BF0)
              : Colors.white,
        ),
      ),
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
          key: ExplorePage.scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              _buildTabBar(width),

              const Divider(color: Colors.white12, height: 1),

              Expanded(
                child: TabBarView(
                  key: ExplorePage.tabBarViewKey,
                  controller: _tabController,
                  children: [
                    _forYouTab(data, vm, context),
                    _trendingTab(data, vm, context),
                    _newsTab(data, vm, context),
                    _sportsTab(data, vm, context),
                    _entertainmentTab(data, vm, context),
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
        key: ExplorePage.tabBarKey,
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
          Tab(key: Key('for_you_tab'), text: "For You"),
          Tab(key: Key('trending_tab'), text: "Trending"),
          Tab(key: Key('news_tab'), text: "News"),
          Tab(key: Key('sports_tab'), text: "Sports"),
          Tab(key: Key('entertainment_tab'), text: "Entertainment"),
        ],
      ),
    );
  }
}

Widget _forYouTab(
  ExploreState data,
  ExploreViewModel vm,
  BuildContext context,
) {
  final theme = Theme.of(context);
  print("For You Tab rebuilt");
  // if (data.isForYouHashtagsLoading ||
  //     data.isSuggestedUsersLoading ||
  //     data.isInterestMapLoading) {
  //   return Center(
  //     key: const Key('for_you_loading'),
  //     child: CircularProgressIndicator(
  //       key: const Key('for_you_progress_indicator'),
  //       color: theme.brightness == Brightness.light
  //           ? const Color(0xFF1D9BF0)
  //           : Colors.white,
  //     ),
  //   );
  // }

  return ForYouView(
    key: const Key('for_you_content'),
    trendingHashtags: data.forYouHashtags,
    suggestedUsers: data.suggestedUsers,
    forYouTweetsMap: data.interestBasedTweets,
    onRefresh: () => vm.refreshCurrentTab(),
  );
}

Widget _trendingTab(
  ExploreState data,
  ExploreViewModel vm,
  BuildContext context,
) {
  print("Trending Tab rebuilt");
  final theme = Theme.of(context);
  if (data.isHashtagsLoading) {
    return Center(
      key: const Key('trending_loading'),
      child: CircularProgressIndicator(
        key: const Key('trending_progress_indicator'),
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.trendingHashtags.isEmpty) {
    return RefreshIndicator(
      key: const Key('trending_empty_refresh'),
      onRefresh: () async {
        vm.refreshCurrentTab();
      },
      child: Center(
        child: Text(
          key: const Key('trending_empty_text'),
          "No trending hashtags found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF52636d)
                : const Color(0xFF7c838c),
          ),
        ),
      ),
    );
  }
  return RefreshIndicator(
    key: const Key('trending_refresh'),
    onRefresh: () async {
      vm.refreshCurrentTab();
    },
    child: TrendingView(
      key: const Key('trending_content'),
      trendingHashtags: data.trendingHashtags,
    ),
  );
}

Widget _newsTab(ExploreState data, ExploreViewModel vm, BuildContext context) {
  final theme = Theme.of(context);
  print("News Tab rebuilt");
  if (data.isNewsHashtagsLoading) {
    return Center(
      key: const Key('news_loading'),
      child: CircularProgressIndicator(
        key: const Key('news_progress_indicator'),
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.newsHashtags.isEmpty) {
    return RefreshIndicator(
      key: const Key('news_empty_refresh'),
      onRefresh: () async {
        vm.refreshCurrentTab();
      },
      child: Center(
        child: Text(
          key: const Key('news_empty_text'),
          "No News Trending hashtags found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF52636d)
                : const Color(0xFF7c838c),
          ),
        ),
      ),
    );
  }
  return RefreshIndicator(
    key: const Key('news_refresh'),
    onRefresh: () async {
      vm.refreshCurrentTab();
    },
    child: Scrollbar(
      interactive: true,
      radius: const Radius.circular(20),
      thickness: 6,
      child: ListView.builder(
        key: const Key('news_list'),
        padding: const EdgeInsets.all(12),
        itemCount: data.newsHashtags.length,
        itemBuilder: (context, index) {
          final hashtag = data.newsHashtags[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: HashtagItem(hashtag: hashtag),
          );
        },
      ),
    ),
  );
}

Widget _sportsTab(
  ExploreState data,
  ExploreViewModel vm,
  BuildContext context,
) {
  final theme = Theme.of(context);
  print("Sports Tab rebuilt");
  if (data.isSportsHashtagsLoading) {
    return Center(
      key: const Key('sports_loading'),
      child: CircularProgressIndicator(
        key: const Key('sports_progress_indicator'),
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.sportsHashtags.isEmpty) {
    return RefreshIndicator(
      key: const Key('sports_empty_refresh'),
      onRefresh: () async {
        vm.refreshCurrentTab();
      },
      child: Center(
        child: Text(
          key: const Key('sports_empty_text'),
          "No Sports Trending hashtags found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF52636d)
                : const Color(0xFF7c838c),
          ),
        ),
      ),
    );
  }
  return RefreshIndicator(
    key: const Key('sports_refresh'),
    onRefresh: () async {
      vm.refreshCurrentTab();
    },
    child: Scrollbar(
      interactive: true,
      radius: const Radius.circular(20),
      thickness: 6,
      child: ListView.builder(
        key: const Key('sports_list'),
        padding: const EdgeInsets.all(12),
        itemCount: data.sportsHashtags.length,
        itemBuilder: (context, index) {
          final hashtag = data.sportsHashtags[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: HashtagItem(hashtag: hashtag),
          );
        },
      ),
    ),
  );
}

Widget _entertainmentTab(
  ExploreState data,
  ExploreViewModel vm,
  BuildContext context,
) {
  final theme = Theme.of(context);
  print("Entertainment Tab rebuilt");
  if (data.isEntertainmentHashtagsLoading) {
    return Center(
      key: const Key('entertainment_loading'),
      child: CircularProgressIndicator(
        key: const Key('entertainment_progress_indicator'),
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.entertainmentHashtags.isEmpty) {
    return RefreshIndicator(
      key: const Key('entertainment_empty_refresh'),
      onRefresh: () async {
        vm.refreshCurrentTab();
      },
      child: Center(
        child: Text(
          key: const Key('entertainment_empty_text'),
          "No Entertainment Trending hashtags found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF52636d)
                : const Color(0xFF7c838c),
          ),
        ),
      ),
    );
  }
  return RefreshIndicator(
    key: const Key('entertainment_refresh'),
    onRefresh: () async {
      vm.refreshCurrentTab();
    },
    child: Scrollbar(
      interactive: true,
      radius: const Radius.circular(20),
      thickness: 6,
      child: ListView.builder(
        key: const Key('entertainment_list'),
        padding: const EdgeInsets.all(12),
        itemCount: data.entertainmentHashtags.length,
        itemBuilder: (context, index) {
          final hashtag = data.entertainmentHashtags[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: HashtagItem(hashtag: hashtag),
          );
        },
      ),
    ),
  );
}
