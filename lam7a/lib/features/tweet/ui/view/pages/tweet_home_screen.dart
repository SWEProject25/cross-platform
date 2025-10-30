import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

/// Home screen with FAB button to navigate to AddTweetScreen
class TweetHomeScreen extends ConsumerWidget {
  const TweetHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetsAsync = ref.watch(tweetHomeViewModelProvider);

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
              ref.read(tweetHomeViewModelProvider.notifier).refreshTweets();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tweetHomeViewModelProvider.notifier).refreshTweets();
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
          // Check authentication before navigating
          final authState = ref.read(authenticationProvider);
          
          if (!authState.isAuthenticated || authState.user == null) {
            // Show error if not authenticated
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please log in to post a tweet'),
                  backgroundColor: Pallete.errorColor,
                ),
              );
            }
            return;
          }
          
          final userId = authState.user!.userId ?? '1';
          
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTweetScreen(
                userId: userId,
              ),
            ),
          );
          // Refresh tweets after returning from add screen
          ref.read(tweetHomeViewModelProvider.notifier).refreshTweets();
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
