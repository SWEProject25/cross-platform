import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'tweet_body_summary_widget.dart';
import '../../repository/tweet_repository.dart';

///  FutureProvider → Fetches summary when page opens
final aiSummaryProvider = FutureProvider.family<String, String>((
  ref,
  tweetId,
) async {
  final repo = ref.read(tweetRepositoryProvider);
  final summary = await repo.getTweetSummery(tweetId);
  return summary;
});

class TweetAiSummery extends ConsumerWidget {
  final TweetModel tweet;

  const TweetAiSummery({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(aiSummaryProvider(tweet.id));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("AI Summary"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: Colors.grey),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OriginalTweetCard(tweet: tweet),

            const SizedBox(height: 16),

            Expanded(
              child: summaryAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    "Failed to load summary.\n$err",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (summary) => SingleChildScrollView(
                  child: Text(
                    summary,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
