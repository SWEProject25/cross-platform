import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_result_state.dart';
import '../../viewmodel/search_results_viewmodel.dart';
import '../../../../common/widgets/tweets_list.dart';

class TopTab extends ConsumerStatefulWidget {
  final SearchResultState data;
  final SearchResultsViewmodel vm;
  const TopTab({super.key, required this.data, required this.vm});

  static const Key contentKey = Key('top_tab_content');

  @override
  ConsumerState<TopTab> createState() => _TopTabState();
}

class _TopTabState extends ConsumerState<TopTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("Top Tab rebuilt");
    super.build(context);

    final data = widget.data;

    if (data.isTopLoading && data.topTweets.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (data.topTweets.isEmpty && !data.isTopLoading) {
      return Center(
        child: Text(
          "No tweets found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? Colors.black
                : Colors.white54,
            fontSize: 16,
          ),
        ),
      );
    }

    return TweetsListView(
      key: TopTab.contentKey,
      tweets: data.topTweets,
      hasMore: data.hasMoreTop,
      onRefresh: () async => widget.vm.refreshCurrentTab(),
      onLoadMore: () async => widget.vm.loadMoreTop(),
    );
  }
}
