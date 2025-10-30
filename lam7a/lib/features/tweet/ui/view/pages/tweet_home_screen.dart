import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/features/authentication/service/user_api_service.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

/// Provider to fetch all tweets
final allTweetsProvider = FutureProvider((ref) async {
  final repository = await ref.watch(tweetRepositoryProvider.future);
  return await repository.fetchAllTweets();
});

/// Home screen with FAB button to navigate to AddTweetScreen
class TweetHomeScreen extends ConsumerWidget {
  const TweetHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetsAsync = ref.watch(allTweetsProvider);

    return Scaffold(
      backgroundColor: Pallete.blackColor,
      appBar: AppBar(
        backgroundColor: Pallete.blackColor,
        title: const Text(
          'Home',
          style: TextStyle(color: Pallete.whiteColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Pallete.whiteColor),
            onPressed: () {
              ref.invalidate(allTweetsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allTweetsProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: tweetsAsync.when(
          data: (tweets) {
            if (tweets.isEmpty) {
              return const Center(
                child: Text(
                  'No tweets yet. Tap + to create your first tweet!',
                  style: TextStyle(color: Pallete.greyColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            
            // Sort tweets by date (newest first)
            final sortedTweets = tweets.toList()
              ..sort((a, b) => b.date.compareTo(a.date));
            
            return ListView.builder(
              itemCount: sortedTweets.length,
              itemBuilder: (context, index) {
                final tweet = sortedTweets[index];
                return Column(
                  children: [
                    TweetSummaryWidget(
                      tweetId: tweet.id,
                      tweetData: tweet, // Pass pre-loaded data to avoid 404 fetch
                    ),
                    const Divider(
                      color: Pallete.borderColor,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Pallete.borderHover,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Pallete.errorColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading tweets',
                  style: TextStyle(color: Pallete.errorColor, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(color: Pallete.greyColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get current user ID
          final currentUserAsync = ref.read(currentUserProvider);
          
          String userId = '1'; // Default to 1
          await currentUserAsync.when(
            data: (user) {
              userId = user.userId.toString();
            },
            loading: () {
              print('⏳ User not loaded yet, using default ID: 1');
            },
            error: (error, stack) {
              print('❌ Error loading user, using default ID: 1');
            },
          );
          
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTweetScreen(
                userId: userId, // Use actual user ID from backend
              ),
            ),
          );
          // Refresh tweets after returning from add screen
          ref.invalidate(allTweetsProvider);
        },
        backgroundColor: Pallete.borderHover,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}
