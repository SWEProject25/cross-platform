import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/explore_state.dart';
import '../viewmodel/explore_viewmodel.dart';

import 'explore_and_trending/for_you_view.dart';
import 'explore_and_trending/trending_view.dart';

import '../../../common/widgets/tweets_list.dart';
import '../widgets/hashtag_list_item.dart';

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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
  if (data.isForYouHashtagsLoading ||
      data.isSuggestedUsersLoading ||
      data.isInterestMapLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  return ForYouView(
    trendingHashtags: data.forYouHashtags,
    suggestedUsers: data.suggestedUsers,
    forYouTweetsMap: data.interestBasedTweets,
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

Widget _newsTab(ExploreState data, ExploreViewModel vm, BuildContext context) {
  final theme = Theme.of(context);
  print("News Tab rebuilt");
  if (data.isNewsHashtagsLoading) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.newsHashtags.isEmpty) {
    return Center(
      child: Text(
        "No News Trending hashtags found",
        style: TextStyle(
          color: theme.brightness == Brightness.light
              ? const Color(0xFF52636d)
              : const Color(0xFF7c838c),
        ),
      ),
    );
  }
  return Scrollbar(
    interactive: true,
    radius: const Radius.circular(20),
    thickness: 6,

    child: ListView.builder(
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
      child: CircularProgressIndicator(
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.sportsHashtags.isEmpty) {
    return Center(
      child: Text(
        "No Sports Trending hashtags found",
        style: TextStyle(
          color: theme.brightness == Brightness.light
              ? const Color(0xFF52636d)
              : const Color(0xFF7c838c),
        ),
      ),
    );
  }
  return Scrollbar(
    interactive: true,
    radius: const Radius.circular(20),
    thickness: 6,

    child: ListView.builder(
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
      child: CircularProgressIndicator(
        color: theme.brightness == Brightness.light
            ? const Color(0xFF1D9BF0)
            : Colors.white,
      ),
    );
  }
  if (data.entertainmentHashtags.isEmpty) {
    return Center(
      child: Text(
        "No Entertainment Trending hashtags found",
        style: TextStyle(
          color: theme.brightness == Brightness.light
              ? const Color(0xFF52636d)
              : const Color(0xFF7c838c),
        ),
      ),
    );
  }
  return Scrollbar(
    interactive: true,
    radius: const Radius.circular(20),
    thickness: 6,

    child: ListView.builder(
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
  );
}
