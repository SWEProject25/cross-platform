import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
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
      Future.delayed(const Duration(milliseconds: 250), () {
        final overlay = Overlay.of(context);
        if (!mounted || overlay == null) {
          return;
        }
        showTopSnackBar(
          overlay,
          Card(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "Reposted Successfully",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      });
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
                    title: Text(
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
                    title: Text(
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
    var themeData = Theme.of(context);
    final tweet = widget.tweetState.tweet.value;
    final postId = widget.tweetState.tweet.value!.id;
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
              SvgPicture.asset(
                AppIcons.tweet_reply,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  themeData.colorScheme.secondary,
                  BlendMode.srcIn,
                ),
              ),
              ref
                  .watch(tweetViewModelProvider(tweetId))
                  .when(
                    data: (state) => Text(
                      "${state.commentCountUpdated ?? commentsNumStr}",
                      style: themeData.textTheme.bodyMedium,
                    ),
                    loading: () => Text(
                      commentsNumStr,
                      style: themeData.textTheme.bodyMedium,
                    ),

                    error: (_, __) => Text(
                      commentsNumStr,
                      style: themeData.textTheme.bodyMedium,
                    ),
                  ),
            ],
          ),
          onPressed: () async {
            final authState = ref.read(authenticationProvider);
            final user = authState.user;
            if (user == null || user.id == null) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in to reply')),
                );
              }
              return;
            }

            final parentId = int.tryParse(postId);
            if (parentId == null) {
              return;
            }

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddTweetScreen(
                  userId: user.id!,
                  parentPostId: parentId,
                  isReply: true,
                ),
              ),
            );

            // Refresh replies and parent tweet (comments count) after returning
            ref.invalidate(tweetRepliesViewModelProvider(postId));
            ref.invalidate(tweetViewModelProvider(postId));
          },
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
                      SvgPicture.asset(
                        AppIcons.tweet_retweet,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          state.isReposted
                              ? Colors.green
                              : themeData.colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        '${state.repostCountUpdated ?? repostsNumStr}',
                        style: state.isReposted
                            ? themeData.textTheme.bodyMedium?.copyWith(
                                color: Colors.green,
                              )
                            : themeData.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  loading: () => SvgPicture.asset(
                    AppIcons.tweet_retweet,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  error: (_, __) => SvgPicture.asset(
                    AppIcons.tweet_retweet,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
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
                      SvgPicture.asset(
                        state.isLiked
                            ? AppIcons.tweet_like_filled
                            : AppIcons.tweet_like_outline,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          state.isLiked
                              ? Colors.redAccent
                              : themeData.colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        "${state.likeCountUpdated ?? likesNumStr}",
                        style: TextStyle(
                          color: ref
                              .watch(tweetViewModelProvider(tweetId))
                              .when(
                                data: (state) => state.isLiked
                                    ? Colors.redAccent
                                    : themeData.colorScheme.secondary,
                                loading: () => Colors.grey,
                                error: (_, __) => Colors.grey,
                              ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  loading: () => SvgPicture.asset(
                    AppIcons.tweet_like_outline,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  error: (_, __) => SvgPicture.asset(
                    AppIcons.tweet_like_outline,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
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
              Text(veiwsNumStr, style: themeData.textTheme.bodyMedium),
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
