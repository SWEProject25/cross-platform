import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TweetFeed extends ConsumerStatefulWidget {
  const TweetFeed({super.key, required this.tweetState});
  final TweetState tweetState;

  @override
  ConsumerState<TweetFeed> createState() {
    return _TweetFeedState();
  }
}

class _TweetFeedState extends ConsumerState<TweetFeed>
    with TickerProviderStateMixin {
  // for the like animation
  late AnimationController _controller;
  late AnimationController _controllerRepost;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scaleAnimationRepost;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controllerRepost = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimationRepost = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controllerRepost, curve: Curves.easeOut),
    );
  }

  void _handlerepost() {
    final tweetId = widget.tweetState.tweet.value?.id;
    if (tweetId == null) return;

    ref
        .read(tweetViewModelProvider(tweetId).notifier)
        .handleRepost(controllerRepost: _controllerRepost);
    if (ref.read(tweetViewModelProvider(tweetId).notifier).getisReposted()) {
      showTopSnackBar(
        Overlay.of(context),
        Card(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children:  [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Reposted Successfully",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showRepostQuoteOptions(BuildContext context) {
    final tweetId = widget.tweetState.tweet.value?.id;
    if (tweetId == null) return;

    if (!ref.read(tweetViewModelProvider(tweetId).notifier).getisReposted()) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.repeat, color: Colors.blue),
                    title:  Text(
                      "Repost",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      _handlerepost();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.format_quote,
                      color: Colors.green,
                    ),
                    title:  Text(
                      "Quote",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () async {
                      final authState = ref.read(authenticationProvider);
                      final user = authState.user;
                      if (user == null || user.id == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please log in to quote'),
                            ),
                          );
                        }
                        Navigator.pop(context);
                        return;
                      }

                      final parentId = int.tryParse(tweetId);
                      if (parentId == null) {
                        Navigator.pop(context);
                        return;
                      }

                      Navigator.pop(context);
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddTweetScreen(
                            userId: user.id!,
                            parentPostId: parentId,
                            isQuote: true,
                          ),
                        ),
                      );

                      ref.invalidate(tweetViewModelProvider(tweetId));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      _handlerepost();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safe null check
    var themeData= Theme.of(context);
    final tweet = widget.tweetState.tweet.value;
    if (tweet == null) {
      return const SizedBox.shrink(); // Return empty if no tweet data
    }

    final tweetId = tweet.id;
    final tweetState = ref.watch(tweetViewModelProvider(tweetId));
    String commentsNumStr = '0';
    String veiwsNumStr = '0';
    String likesNumStr = '0';
    String repostsNumStr = '0';

    tweetState.whenData((tweetState) {
      final stateTweet = tweetState.tweet.value;
      if (stateTweet != null) {
        final viewModel = ref.read(tweetViewModelProvider(tweetId).notifier);

        final commNum = (stateTweet.comments ?? 0).toDouble();
        final likesNum = (stateTweet.likes ?? 0).toDouble();
        final repostNum = (stateTweet.repost ?? 0).toDouble();
        final viewsNum = (stateTweet.views ?? 0).toDouble();

        commentsNumStr = viewModel.howLong(commNum);
        likesNumStr = viewModel.howLong(likesNum);
        repostsNumStr = viewModel.howLong(repostNum);
        veiwsNumStr = viewModel.howLong(viewsNum);
      }
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Comment
        IconButton(
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
          icon: Row(
            children: [
               Icon(
                Icons.mode_comment_outlined,
                color: themeData.colorScheme.secondary,
                size: 20,
              ),
              Text(
          commentsNumStr,
          style: themeData.textTheme.bodyMedium
        ),
            ],
            
          ),
          onPressed: ref
              .read(tweetViewModelProvider(tweetId).notifier)
              .handleComment,
        ),

        // Repost
        ScaleTransition(
          scale: _scaleAnimationRepost,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: ref
                .watch(tweetViewModelProvider(tweetId))
                .when(
                  data: (state) => Row(
                    children: [
                      Icon(
                        Icons.repeat,
                        color: state.isReposted ? Colors.green :themeData.colorScheme.secondary,
                        size: 20,
                      ),
                      Text(
                        repostsNumStr,
                        style:  themeData.textTheme.bodyMedium
                      ),
                    ],
                  ),
                  loading: () =>
                      const Icon(Icons.repeat, color: Colors.grey, size: 20),
                  error: (_, __) =>
                      const Icon(Icons.repeat, color: Colors.grey, size: 20),
                ),
            onPressed: () {
              _showRepostQuoteOptions(context);
            },
          ),
        ),

        // Like
        ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: ref
                .watch(tweetViewModelProvider(tweetId))
                .when(
                  data: (state) => Row(
                    children: [
                      Icon(
                        state.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: state.isLiked
                            ? Colors.redAccent
                            : themeData.colorScheme.secondary,
                        size: 20,
                      ),
                      Text(
                        likesNumStr,
                        style: TextStyle(
                          color: ref
                              .watch(tweetViewModelProvider(tweetId))
                              .when(
                                data: (state) => state.isLiked
                                    ? Colors.redAccent
                                    :  themeData.colorScheme.secondary,
                                loading: () => Colors.grey,
                                error: (_, __) => Colors.grey,
                              ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
                  ),
                  error: (_, __) => const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
            onPressed: () {
              ref
                  .read(tweetViewModelProvider(tweetId).notifier)
                  .handleLike(controller: _controller);
            },
          ),
        ),

        // Views
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Row(
            children: [
               Icon(
                Icons.bar_chart_outlined,
                color: themeData.colorScheme.secondary,
                size: 20,
              ),
              Text(
          veiwsNumStr,
          style: themeData.textTheme.bodyMedium,
        ),
            ],
          ),
          onPressed: ref
              .read(tweetViewModelProvider(tweetId).notifier)
              .handleViews,
        ),
      ],
    );
  }
}
