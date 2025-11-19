import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_likers_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_reposters_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';

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
      showTopSnackBar(
        Overlay.of(context),
        Card(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Reposted Successfully",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
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
      backgroundColor: Colors.black,
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
                    const Text(
                      'Reposted by',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: repostersAsync.when(
                        data: (users) {
                          if (users.isEmpty) {
                            return const Center(
                              child: Text(
                                'No reposts yet',
                                style: TextStyle(color: Colors.grey),
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
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[700],
                                  backgroundImage: profileImage != null &&
                                          profileImage.isNotEmpty
                                      ? NetworkImage(profileImage)
                                      : null,
                                  child: profileImage == null ||
                                          profileImage.isEmpty
                                      ? Text(
                                          username.isNotEmpty
                                              ? username[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  displayName,
                                  style:
                                      const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '@$username',
                                  style:
                                      const TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) => const Center(
                          child: Text(
                            'Failed to load reposters',
                            style: TextStyle(color: Colors.redAccent),
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
      backgroundColor: Colors.black,
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
                    const Text(
                      'Liked by',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: likersAsync.when(
                        data: (likers) {
                          if (likers.isEmpty) {
                            return const Center(
                              child: Text(
                                'No likes yet',
                                style: TextStyle(color: Colors.grey),
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
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[700],
                                  backgroundImage: profileImage != null &&
                                          profileImage.isNotEmpty
                                      ? NetworkImage(profileImage)
                                      : null,
                                  child: profileImage == null ||
                                          profileImage.isEmpty
                                      ? Text(
                                          username.isNotEmpty
                                              ? username[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  displayName,
                                  style:
                                      const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '@$username',
                                  style:
                                      const TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) => const Center(
                          child: Text(
                            'Failed to load likers',
                            style: TextStyle(color: Colors.redAccent),
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
      backgroundColor: Colors.black,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.repeat, color: Colors.blue),
                  title: const Text("Repost",style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _handlerepost();
                     Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_quote, color: Colors.green),
                  title: const Text("Quote",style: TextStyle(color: Colors.white)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tweet.when(
              data: (tweet) => tweet.value != null ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  formatDate(tweet.value!.date),
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                  ),
                ),
              ) : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
              error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            tweet.when(
              data: (tweet) => tweet.value != null ? Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  DateFormat('d MMM yy').format(tweet.value!.date),
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                  ),
                ),
              ) : const SizedBox.shrink(),
              loading: () => const CircularProgressIndicator(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  veiwsNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Views",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey.shade800,
          height: 20,
          indent: 18,
          endIndent: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(
                        repostsNumStr,
                        style: const TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Reposts",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        qoutesNumStr,
                        style: const TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Quotes",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  tweet.when(
                    data: (tweet) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        likesNumStr,
                        style: const TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    loading: () => const CircleAvatar(),
                    error: (e, st) => Text('Error $e'),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Likes",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                    icon: const Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.grey,
                      size: 22,
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
                          data: (state) => Icon(
                            Icons.repeat,
                            color: state.isReposted
                                ? Colors.green
                                : Colors.grey,
                            size: 22,
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
                          data: (state) => Icon(
                            state.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: state.isLiked
                                ? Colors.redAccent
                                : Colors.grey,
                            size: 22,
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
