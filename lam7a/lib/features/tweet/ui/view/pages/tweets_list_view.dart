import 'package:flutter/material.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

class TweetListView extends StatefulWidget {
  final List<TweetModel> tweets;

  const TweetListView({super.key, required this.tweets});

  @override
  State<TweetListView> createState() => _TweetListViewState();
}

class _TweetListViewState extends State<TweetListView>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.tweets.length,
      itemBuilder: (_, index) {
        return TweetSummaryWidget(
          tweetId: widget.tweets[index].id,
          tweetData: widget.tweets[index],
        );
      },
    );
  }
}
