import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final ScrollController _controller = ScrollController();

  // overscroll pull distance
  double _pullDistance = 0.0;
  bool _loadTriggered = false;
  bool _isLoadingMore = false;

  static const double triggerDistance = 90.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _triggerLoadMore() async {
    if (_isLoadingMore || !widget.hasMore) return;
    setState(() => _isLoadingMore = true);

    await widget.onLoadMore();

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        _pullDistance = 0;
        _loadTriggered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // ➤ Detect overscroll at bottom
          if (notification is OverscrollNotification &&
              notification.overscroll > 0 &&
              widget.hasMore) {
            setState(() {
              _pullDistance += notification.overscroll;

              if (_pullDistance > triggerDistance && !_loadTriggered) {
                _loadTriggered = true;
                _triggerLoadMore();
              }
            });
          }

          // ➤ Reset when scrolling stops
          if (notification is ScrollEndNotification) {
            setState(() {
              if (!_isLoadingMore) {
                _pullDistance = 0;
                _loadTriggered = false;
              }
            });
          }

          return false;
        },
        child: Stack(
          children: [
            // MAIN LIST
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: (_isLoadingMore
                    ? 70
                    : _pullDistance.clamp(0, triggerDistance)),
              ),
              child: ListView.builder(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.tweets.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TweetSummaryWidget(
                        tweetId: widget.tweets[index].id,
                        tweetData: widget.tweets[index],
                      ),
                      SizedBox(height: 4),
                      Divider(
                        height: 1,
                        thickness: 0.3,
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color.fromARGB(120, 83, 99, 110)
                            : const Color(0xFF8B98A5),
                      ),
                    ],
                  );
                },
              ),
            ),

            // BOTTOM GAP + LOADER
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _isLoadingMore
                  ? 50
                  : _pullDistance.clamp(0, triggerDistance),
              child: Center(
                child: (_isLoadingMore || _pullDistance > 10)
                    ? const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xFF1d9bf0),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
