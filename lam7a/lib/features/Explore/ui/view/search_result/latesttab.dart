import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_result_state.dart';
import '../../viewmodel/search_results_viewmodel.dart';
import '../../../../common/widgets/tweets_list.dart';

class LatestTab extends ConsumerStatefulWidget {
  final SearchResultState data;
  final SearchResultsViewmodel vm;
  const LatestTab({super.key, required this.data, required this.vm});

  @override
  ConsumerState<LatestTab> createState() => _LatestTabState();
}

class _LatestTabState extends ConsumerState<LatestTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("Latest Tab rebuilt");
    super.build(context);
    final theme = Theme.of(context);

    final data = widget.data;

    if (data.isLatestLoading && data.latestTweets.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      );
    }

    if (data.latestTweets.isEmpty && !data.isLatestLoading) {
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
      tweets: data.latestTweets,
      hasMore: data.hasMoreLatest,
      onRefresh: () async => widget.vm.refreshCurrentTab(),
      onLoadMore: () async => widget.vm.loadMoreLatest(),
    );
  }
}
