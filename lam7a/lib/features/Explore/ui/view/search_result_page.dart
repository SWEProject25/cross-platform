import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/tab_button.dart';
import '../widgets/search_appbar.dart';
import '../../../common/widgets/user_tile.dart';
import '../../../common/widgets/tweets_list.dart';
import '../viewmodel/search_results_viewmodel.dart';
import '../state/search_result_state.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  const SearchResultPage({super.key, required this.hintText});

  final String hintText;

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchResultsViewModelProvider.notifier).search(widget.hintText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchResultsViewModelProvider);
    final vm = ref.read(searchResultsViewModelProvider.notifier);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: SearchAppbar(width: width, hintText: widget.hintText),

      body: state.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),

        error: (e, st) => Center(
          child: Text("Error: $e", style: const TextStyle(color: Colors.red)),
        ),

        data: (data) {
          return Column(
            children: [
              _tabs(vm, data.currentResultType, width),
              const Divider(color: Colors.white12, height: 1),

              Expanded(child: _buildTabContent(data, vm)),
            ],
          );
        },
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
///  TABS
/// ---------------------------------------------------------------------------

Widget _tabs(
  SearchResultsViewmodel vm,
  CurrentResultType selected,
  double width,
) {
  Alignment getAlignment() {
    switch (selected) {
      case CurrentResultType.top:
        return const Alignment(-0.74, 0);
      case CurrentResultType.latest:
        return const Alignment(0.0, 0);
      case CurrentResultType.people:
        return const Alignment(0.76, 0);
    }
  }

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Row(
          children: [
            Expanded(
              child: TabButton(
                label: "Top",
                selected: selected == CurrentResultType.top,
                onTap: () => vm.selectTab(CurrentResultType.top),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: TabButton(
                label: "Latest",
                selected: selected == CurrentResultType.latest,
                onTap: () => vm.selectTab(CurrentResultType.latest),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: TabButton(
                label: "People",
                selected: selected == CurrentResultType.people,
                onTap: () => vm.selectTab(CurrentResultType.people),
              ),
            ),
          ],
        ),
      ),

      // Sliding indicator bar
      SizedBox(
        height: 3,
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: getAlignment(),
              child: Container(
                width: width * 0.15,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// ---------------------------------------------------------------------------
///  TAB CONTENT HANDLER
/// ---------------------------------------------------------------------------

Widget _buildTabContent(SearchResultState data, SearchResultsViewmodel vm) {
  switch (data.currentResultType) {
    case CurrentResultType.people:
      return _peopleTab(data, vm);

    case CurrentResultType.top:
      return _topTab(data, vm);

    case CurrentResultType.latest:
      return _latestTab(data, vm);
  }
}

/// ---------------------------------------------------------------------------
///  PEOPLE TAB
/// ---------------------------------------------------------------------------

Widget _peopleTab(SearchResultState data, SearchResultsViewmodel vm) {
  if (data.isPeopleLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.searchedPeople.isEmpty && data.isPeopleLoading) {
    return const Center(
      child: Text(
        "No users found",
        style: TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
  print("BUILDING PEOPLE TAB WITH ${data.searchedPeople.length} USERS");
  return RefreshIndicator(
    color: Colors.white,
    backgroundColor: Colors.black,
    onRefresh: () async {}, // if needed later

    child: ListView.builder(
      padding: const EdgeInsets.only(top: 12),
      itemCount: data.searchedPeople.length,
      itemBuilder: (context, i) {
        final user = data.searchedPeople[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: UserTile(user: user),
        );
      },
    ),
  );
}

/// ---------------------------------------------------------------------------
///  TOP TAB
/// ---------------------------------------------------------------------------

Widget _topTab(SearchResultState data, SearchResultsViewmodel vm) {
  if (data.isTopLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.topTweets.isEmpty && data.isTopLoading) {
    return const Center(
      child: Text(
        "No tweets found",
        style: TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
  print(
    "BUILDING TOP TAB WITH ${data.topTweets.length} TWEETS\n${data.topTweets.map((t) => t.id.toString()).join("\n")}",
  );
  return TweetsListView(
    tweets: data.topTweets,
    hasMore: data.hasMoreTop,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreTop(),
  );
}

/// ---------------------------------------------------------------------------
///  LATEST TAB
/// ---------------------------------------------------------------------------

Widget _latestTab(SearchResultState data, SearchResultsViewmodel vm) {
  if (data.isLatestLoading) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
  if (data.latestTweets.isEmpty && data.isLatestLoading) {
    return const Center(
      child: Text(
        "No tweets found",
        style: TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
  print(
    "BUILDING LATEST TAB WITH ${data.latestTweets.length} TWEETS\n${data.latestTweets.map((t) => t.id.toString()).join("\n")}",
  );
  return TweetsListView(
    tweets: data.latestTweets,
    hasMore: data.hasMoreLatest,
    onRefresh: () async => vm.refreshCurrentTab(),
    onLoadMore: () async => vm.loadMoreLatest(),
  );
}
