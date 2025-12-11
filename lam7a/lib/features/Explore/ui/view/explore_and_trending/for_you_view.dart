import 'package:flutter/material.dart';
import '../../../model/trending_hashtag.dart';
import '../../../../../core/models/user_model.dart';
import '../../widgets/hashtag_list_item.dart';
import '../../../../common/widgets/user_tile.dart';
import 'connect_view.dart';
import '../../../../common/models/tweet_model.dart';
import '../../../../common/widgets/static_tweets_list.dart';

class ForYouView extends StatelessWidget {
  final List<TrendingHashtag> trendingHashtags;
  final List<UserModel> suggestedUsers;
  final Map<String, List<TweetModel>> forYouTweetsMap;

  const ForYouView({
    super.key,
    required this.trendingHashtags,
    required this.suggestedUsers,
    required this.forYouTweetsMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        // ----- Trending Hashtags Section -----
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trendingHashtags.length,
          itemBuilder: (context, index) {
            final hashtag = trendingHashtags[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HashtagItem(hashtag: hashtag, showOrder: false),
            );
          },
        ),

        const SizedBox(height: 16),

        // Divider after trending hashtags
        Divider(
          height: 1,
          thickness: 0.3,
          color: theme.brightness == Brightness.light
              ? const Color.fromARGB(120, 83, 99, 110)
              : const Color(0xFF8B98A5),
        ),

        const SizedBox(height: 24),

        // ----- Who to follow Section -----
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Who to follow",
            style: TextStyle(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFFFFFFFF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ----- Suggested Users List -----
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestedUsers.length,
          itemBuilder: (context, index) {
            final user = suggestedUsers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: UserTile(user: user),
            );
          },
        ),

        const SizedBox(height: 12),

        // Show more button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConnectView()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Show more",
                style: TextStyle(
                  color: Color(0xFF1D9BF0),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Divider after who to follow section
        Divider(
          height: 1,
          thickness: 0.3,
          color: theme.brightness == Brightness.light
              ? const Color.fromARGB(120, 83, 99, 110)
              : const Color(0xFF8B98A5),
        ),

        const SizedBox(height: 16),

        // ----- For You Tweets Sections -----
        // Map through each interest and its tweets
        ...forYouTweetsMap.entries.map((entry) {
          final interest = entry.key;
          final tweets = entry.value;

          // Skip if no tweets for this interest
          if (tweets.isEmpty) return const SizedBox.shrink();

          return Column(
            children: [
              StaticTweetsListView(interest: interest, tweets: tweets),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }
}
