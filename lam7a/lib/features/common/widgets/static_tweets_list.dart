import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/Explore/ui/view/explore_and_trending/interest_view.dart';

class StaticTweetsListView extends ConsumerWidget {
  final List<TweetModel> tweets;
  final String? interest;
  final bool selfScrolling;

  const StaticTweetsListView({
    super.key,
    required this.tweets,
    this.interest,
    this.selfScrolling = false,
  });

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // -----------------------------------------------------
    // CASE 1: List scrolls by itself (used directly in a page)
    // -----------------------------------------------------
    if (selfScrolling) {
      return ListView.separated(
        itemCount: tweets.length + (interest != null ? 1 : 0),
        separatorBuilder: (_, _) => _divider(theme),
        itemBuilder: (_, index) {
          if (interest != null && index == 0) {
            return _interestHeader(context, theme);
          }

          final tweet = tweets[interest != null ? index - 1 : index];
          return TweetSummaryWidget(tweetId: tweet.id, tweetData: tweet);
        },
      );
    }

    // -----------------------------------------------------
    // CASE 2: Parent scrolls (this widget is inside a big scroll view)
    // -----------------------------------------------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (interest != null) _interestHeader(context, theme),
        const SizedBox(height: 2),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tweets.length,
          separatorBuilder: (_, __) => _divider(theme),
          itemBuilder: (_, index) {
            return TweetSummaryWidget(
              tweetId: tweets[index].id,
              tweetData: tweets[index],
            );
          },
        ),

        _divider(theme),
      ],
    );
  }

  Widget _interestHeader(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => InterestView(interest: interest!)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              interest!,
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF0D0D0D)
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.brightness == Brightness.light
                  ? const Color.fromARGB(255, 33, 33, 33)
                  : const Color(0xFF8B98A5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 2,
      thickness: 0.2,
      color: theme.brightness == Brightness.light
          ? const Color.fromARGB(120, 83, 99, 110)
          : const Color(0xFF8B98A5),
    );
  }
}
