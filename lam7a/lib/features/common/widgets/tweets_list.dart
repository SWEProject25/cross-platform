import 'package:flutter/material.dart';
import '../../tweet/ui/widgets/tweet_summary_widget.dart';
import '../models/tweet_model.dart';
import '../../../core/theme/app_pallete.dart';

enum CurrentPage { searchresult } //we testing

class TweetListView extends StatefulWidget {
  final List<TweetModel> initialTweets;
  final Comparator<TweetModel> sortCriteria;
  final Future<List<TweetModel>> Function(int page)? loadMore;
  final CurrentPage? currentPage;

  const TweetListView({
    super.key,
    required this.initialTweets,
    required this.sortCriteria,
    this.loadMore,
    this.currentPage,
  });

  @override
  State<TweetListView> createState() => _TweetListViewState();
}

class _TweetListViewState extends State<TweetListView> {
  final ScrollController _scrollController = ScrollController();
  late List<TweetModel> _tweets;
  bool _isLoadingMore = false;
  int _pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _tweets = [...widget.initialTweets]..sort(widget.sortCriteria);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (widget.loadMore == null) return;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);

    final newTweets = await widget.loadMore!.call(_pageIndex);
    _pageIndex++;

    _tweets.addAll(newTweets);
    _tweets.sort(widget.sortCriteria);

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void didUpdateWidget(covariant TweetListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-sort on external update
    _tweets = [...widget.initialTweets]..sort(widget.sortCriteria);
  }

  @override
  Widget build(BuildContext context) {
    if (_tweets.isEmpty) {
      return const Center(
        child: Text(
          'No tweets yet. Tap + to create your first tweet!',
          style: TextStyle(color: Pallete.greyColor, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _tweets.length + (widget.loadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _tweets.length && widget.loadMore != null) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final tweet = _tweets[index];
        return Column(
          children: [
            TweetSummaryWidget(tweetId: tweet.id, tweetData: tweet),
            const Divider(
              color: Pallete.borderColor,
              thickness: 0.5,
              height: 1,
            ),
          ],
        );
      },
    );
  }
}
