import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_likers_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_reposters_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lam7a/core/app_icons.dart';

class TweetDetailedFeed extends ConsumerStatefulWidget {
  const TweetDetailedFeed({super.key, required this.tweetState});
  final TweetState tweetState;
  @override
  ConsumerState<TweetDetailedFeed> createState() {
    return _TweetDetailedFeedState();
  }
}

class _TweetDetailedFeedState extends ConsumerState<TweetDetailedFeed>
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
    // Guard against null tweet
    if (widget.tweetState.tweet.value == null) return;
    
 ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier)
        .handleRepost(
          controllerRepost: _controllerRepost,
        );
    if (ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier).getisReposted()) {
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "Reposted Successfully",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showRepostersBottomSheet(String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final repostersAsync = ref.watch(tweetRepostersViewModelProvider(postId));

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                     Text(
                      'Reposted by',
                      style:Theme.of(context).textTheme.bodyLarge 
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: repostersAsync.when(
                        data: (users) {
                          if (users.isEmpty) {
                            return  Center(
                              child: Text(
                                'No reposts yet',
                                style: Theme.of(context).textTheme.bodyLarge ,
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: users.length,
                            separatorBuilder: (_, __) => Divider(
                              color: Colors.grey.shade800,
                              height: 1,
                            ),
                            itemBuilder: (_, index) {
                              final user = users[index];
                              final username = user.username ?? 'unknown';
                              final displayName =
                                  (user.name != null && user.name!.isNotEmpty)
                                      ? user.name!
                                      : username;
                              final profileImage = user.profileImageUrl;

                              return ListTile(
                                leading: AppUserAvatar(
                                  radius: 20,
                                  imageUrl: profileImage,
                                  displayName: displayName,
                                  username: username,
                                ),
                                title: Text(
                                  displayName,
                                  style:
                                     Theme.of(context).textTheme.bodyLarge ,
                                ),
                                subtitle: Text(
                                  '@$username',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge ,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/profile',
                                    arguments: {'username': username},
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) =>  Center(
                          child: Text(
                            'Failed to load reposters',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLikersBottomSheet(String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final likersAsync = ref.watch(tweetLikersViewModelProvider(postId));

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                     Text(
                      'Liked by',
                      style:Theme.of(context).textTheme.bodyLarge
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: likersAsync.when(
                        data: (likers) {
                          if (likers.isEmpty) {
                            return Center(
                              child: Text(
                                'No likes yet',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: likers.length,
                            separatorBuilder: (_, __) => Divider(
                              color: Colors.grey.shade800,
                              height: 1,
                            ),
                            itemBuilder: (_, index) {
                              final user = likers[index];
                              final username = user.username ?? 'unknown';
                              final displayName =
                                  (user.name != null && user.name!.isNotEmpty)
                                      ? user.name!
                                      : username;
                              final profileImage = user.profileImageUrl;

                              return ListTile(
                                leading: AppUserAvatar(
                                  radius: 20,
                                  imageUrl: profileImage,
                                  displayName: displayName,
                                  username: username,
                                ),
                                title: Text(
                                  displayName,
                                  style:
                                     Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  '@$username',
                                  style:
                                     Theme.of(context).textTheme.bodyLarge,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/profile',
                                    arguments: {'username': username},
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) =>  Center(
                          child: Text(
                            'Failed to load likers',
                            style:Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Handle null tweet (e.g., 404 error)
    if (widget.tweetState.tweet.value == null) {
      return const SizedBox.shrink();
    }
    
    final postId =widget.tweetState.tweet.value!.id;
    final tweetState = ref.watch(tweetViewModelProvider(postId));
    final tweet =tweetState.whenData((tweetState) => tweetState.tweet);
    String veiwsNumStr = '';
    String likesNumStr = '';
    String repostsNumStr = '';
    String qoutesNumStr='';
    tweet.whenData((tweet) {
      if (tweet.value == null) return;
      
      final viewModel = ref.read(
        tweetViewModelProvider(postId).notifier,
      );
    final tweetVal=tweet.value!;
      final likesNum = tweetVal.likes.toDouble();
      final repostNum = tweetVal.repost.toDouble();
      final viewsNum = tweetVal.views.toDouble();
      final qoutesNum= tweetVal.qoutes.toDouble();
      likesNumStr = viewModel.howLong(likesNum);
      repostsNumStr = viewModel.howLong(repostNum);
      veiwsNumStr = viewModel.howLong(viewsNum);
      qoutesNumStr=viewModel.howLong(qoutesNum);
    });
    String formatDate(DateTime date) {
      final formatter = DateFormat('hh:mm a');
      return formatter.format(date);
    }

    void showRepostQuoteOptions(BuildContext context) {
    // Guard against null tweet
    if (widget.tweetState.tweet.value == null) return;
    
    if(!ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier).getisReposted())
    {showModalBottomSheet(
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
                  title:  Text("Repost",style:Theme.of(context).textTheme.bodyLarge,),
                  onTap: () {
                    _handlerepost();
                     Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_quote, color: Colors.green),
                  title:  Text("Quote",style: Theme.of(context).textTheme.bodyLarge),
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

                    final parentId = int.tryParse(postId);
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

                    ref.invalidate(tweetViewModelProvider(postId));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    }
    else 
    {
      _handlerepost();
    }
  }

    return Column(
      children: [
        SizedBox(height: 10),
        // date
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            tweet.when(
              data: (tweet) => tweet.value != null ? Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  formatDate(tweet.value!.date),
                  style:Theme.of(context).textTheme.bodyMedium
                ),
              ) : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
              error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style:Theme.of(context).textTheme.bodyMedium,
            ),
            tweet.when(
              data: (tweet) => tweet.value != null ? Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  DateFormat('d MMM yy').format(tweet.value!.date),
                  style:Theme.of(context).textTheme.bodyMedium
                ),
              ) : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  veiwsNumStr,
                  style:Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              "Views",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
          height: 20,
          indent: 18,
          endIndent: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        repostsNumStr,
                        style:Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  Text(
                    "Reposts",
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ],
              ),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        qoutesNumStr,
                        style:  Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  Text(
                    "Quotes",
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ],
              ),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        likesNumStr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  Text(
                    "Likes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.3,
          color: Colors.grey,
          height: 20,
          indent: 18,
          endIndent: 18,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:  SvgPicture.asset(
                AppIcons.tweet_reply,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.secondary,
                  BlendMode.srcIn,
                ),
              ),
                    onPressed: () async {
                      final authState = ref.read(authenticationProvider);
                      final user = authState.user;
                      if (user == null || user.id == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please log in to reply'),
                            ),
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
                ],
              ),
            ),
             
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimationRepost,
                    child: GestureDetector(
                      onLongPress: () => _showRepostersBottomSheet(postId),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: tweetState.when(
                          data: (state) => SvgPicture.asset(
                        AppIcons.tweet_retweet,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          state.isReposted
                              ? Colors.green
                              : Theme.of(context).colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                          loading: () => const Icon(
                            Icons.repeat,
                            color: Colors.grey,
                            size: 22,
                          ),
                          error: (_, __) => const Icon(
                            Icons.repeat,
                            color: Colors.grey,
                            size: 22,
                          ),
                        ),
                        onPressed: () {
                          showRepostQuoteOptions(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onLongPress: () => _showLikersBottomSheet(postId),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: tweetState.when(
                          data: (state) => SvgPicture.asset(
                        state.isLiked
                         ? AppIcons.tweet_like_filled
                            : AppIcons.tweet_like_outline,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          state.isLiked
                              ? Colors.redAccent
                              : Theme.of(context).colorScheme.secondary,
                              BlendMode.srcIn,
                        ),
                      ),
                          loading: () => const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 22,
                          ),
                          error: (_, __) => const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 22,
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(tweetViewModelProvider(postId).notifier)
                              .handleLike(controller: _controller);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.ios_share,
                      color: Colors.grey,
                      size: 22,
                    ),
                    onPressed: ref
                        .read(tweetViewModelProvider(postId).notifier)
                        .handleShare,
                  ),
                ],
              ),
            ),
          ],
        ),
 
      ],
    );
  }
}
