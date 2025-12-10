import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/Explore/ui/view/explore_and_trending/interest_view.dart';

class StaticTweetsListView extends ConsumerWidget {
  final List<TweetModel> tweets;
  final String? interest;

  const StaticTweetsListView({super.key, required this.tweets, this.interest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest Header Tile
        if (interest != null)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InterestView(interest: interest!),
                ),
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
                          : const Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF536370)
                        : const Color(0xFF8B98A5),
                  ),
                ],
              ),
            ),
          ),

        // Divider after header
        Divider(
          height: 1,
          thickness: 0.3,
          color: theme.brightness == Brightness.light
              ? const Color.fromARGB(120, 83, 99, 110)
              : const Color(0xFF8B98A5),
        ),

        // Tweets List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tweets.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 0.3,
            color: theme.brightness == Brightness.light
                ? const Color.fromARGB(120, 83, 99, 110)
                : const Color(0xFF8B98A5),
          ),
          itemBuilder: (context, index) {
            return TweetSummaryWidget(
              tweetId: tweets[index].id,
              tweetData: tweets[index],
            );
          },
        ),

        // Divider after last tweet
        Divider(
          height: 1,
          thickness: 0.3,
          color: theme.brightness == Brightness.light
              ? const Color.fromARGB(120, 83, 99, 110)
              : const Color(0xFF8B98A5),
        ),
      ],
    );
  }
}
