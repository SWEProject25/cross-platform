import 'package:flutter/material.dart';
import '../../model/trending_hashtag.dart';
import '../../../../core/models/user_model.dart';
import '../widgets/hashtag_list_item.dart';
import '../widgets/suggested_user_item.dart';

class ForYouView extends StatelessWidget {
  final List<TrendingHashtag> trendingHashtags;
  final List<UserModel> suggestedUsers;

  const ForYouView({
    super.key,
    required this.trendingHashtags,
    required this.suggestedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // ----- Trending Hashtags Header ---

        // ----- Trending Hashtags List -----
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trendingHashtags.length,
          itemBuilder: (context, index) {
            final hashtag = trendingHashtags[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: HashtagItem(hashtag: hashtag),
            );
          },
        ),

        const SizedBox(height: 20),

        // ----- Who to follow Header -----
        const Text(
          "Who to follow",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),

        // ----- Suggested Users List -----
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestedUsers.length,
          itemBuilder: (context, index) {
            final user = suggestedUsers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SuggestedUserItem(text: user.username ?? "Unknown"),
            );
          },
        ),
      ],
    );
  }
}
