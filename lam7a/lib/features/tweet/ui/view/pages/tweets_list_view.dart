// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lam7a/features/common/models/tweet_model.dart';
// import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
// import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

// class TweetListView extends StatefulWidget {
//   final List<TweetModel> tweets;
//   int page;
//   TweetListView({super.key, required this.tweets, required this.page});

//   @override
//   State<TweetListView> createState() => _TweetListViewState();
// }

// class _TweetListViewState extends State<TweetListView>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Consumer(
//       builder: (context, ref, child) {
//         final tweetAsync = ref.watch(tweetHomeViewModelProvider);

//         return ListView.builder(
//           itemCount: widget.tweets.length,
//           itemBuilder: (_, index) {
//             if (index >= widget.tweets.length - 2) {
//               ref
//                   .read(tweetHomeViewModelProvider.notifier)
//                   .refreshTweets(2, widget.page);
//             }
//             return TweetSummaryWidget(
//               tweetId: widget.tweets[index].id,
//               tweetData: widget.tweets[index],
//             );
//           },
//         );
//       },
//     );
//   }
// }
