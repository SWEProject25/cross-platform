import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

class TweetsListView extends ConsumerStatefulWidget {
  final List<TweetModel> tweets;
  final bool hasMore;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;

  const TweetsListView({
    super.key,
    required this.tweets,
    required this.hasMore,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  ConsumerState<TweetsListView> createState() => _TweetsListViewState();
}

class _TweetsListViewState extends ConsumerState<TweetsListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  double _lastOffset = 0;
  bool _isBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more
    if (!_isLoadingMore &&
        widget.hasMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.7) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    await widget.onLoadMore();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: _buildTweetList(),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification scroll) {
    if (scroll.metrics.axis != Axis.vertical) return false;

    if (scroll is ScrollUpdateNotification) {
      final current = scroll.metrics.pixels;

      if (current > _lastOffset + 10 && _isBarVisible) {
        setState(() => _isBarVisible = false);
      } else if (current < _lastOffset - 5 && !_isBarVisible) {
        setState(() => _isBarVisible = true);
      }

      _lastOffset = current;
    }
    return false;
  }

  Widget _buildTweetList() {
    if (widget.tweets.isEmpty && !widget.hasMore) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: Text("No tweets found", style: GoogleFonts.oxanium()),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.tweets.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.tweets.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return TweetSummaryWidget(
          tweetId: widget.tweets[index].id,
          tweetData: widget.tweets[index],
        );
      },
    );
  }
}
