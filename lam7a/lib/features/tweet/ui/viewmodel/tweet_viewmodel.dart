import 'package:flutter/animation.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/repository/tweet_updates_repository.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_viewmodel.g.dart';

@riverpod
@Riverpod(keepAlive: true)
class TweetViewModel extends _$TweetViewModel {
  final Logger logger = getLogger(TweetViewModel);

  @override
  FutureOr<TweetState> build(String tweetId) async {
    final repo = ref.read(tweetRepositoryProvider);
    final tweet = await repo.fetchTweetById(tweetId);

    // Get interaction flags from the API service
    // The service stores these after fetching the tweet from backend
    final apiService = ref.read(tweetsApiServiceProvider);
    final interactionFlags = await apiService.getInteractionFlags(tweetId);
    final localViewsOverride = apiService.getLocalViews(tweetId);

    final bool isLiked = interactionFlags?['isLikedByMe'] ?? false;
    final bool isReposted = interactionFlags?['isRepostedByMe'] ?? false;
    final bool isViewed = interactionFlags?['isViewedByMe'] ?? false;

    print(
      '   ✅ isLiked: $isLiked, isReposted: $isReposted, isViewed: $isViewed (from flags), localViewsOverride=$localViewsOverride',
    );

    // If we have a locally stored views override, ensure views never go below it
    final effectiveTweet =
        (localViewsOverride != null && localViewsOverride > tweet.views)
        ? tweet.copyWith(views: localViewsOverride)
        : tweet;

    final tweetsUpdateRepo = ref.read(tweetUpdatesRepositoryProvider);
    tweetsUpdateRepo.joinPost(int.parse(tweetId));
    tweetsUpdateRepo.onPostLikeUpdates(int.parse(tweetId)).listen(_onLikeUpdate);
    tweetsUpdateRepo.onPostRepostUpdates(int.parse(tweetId)).listen(_onRepostUpdate);
    tweetsUpdateRepo.onPostCommentUpdates(int.parse(tweetId)).listen(_onCommentUpdate);

    ref.onDispose(() {
      logger.i("Disposing TweetViewModel for tweetId: $tweetId");
      tweetsUpdateRepo.leavePost(int.parse(tweetId));
    });

    return TweetState(
      isLiked: isLiked,
      isReposted: isReposted,
      isViewed: isViewed,
      tweet: AsyncData(effectiveTweet),
      
    );
  }

  void _onLikeUpdate(int count) {
    logger.i("Received like update: $count through socket on tweet id ${state.value?.tweet.value?.id ?? 'unknown'}");
    if (state.value == null || !state.value!.tweet.hasValue || state.value!.tweet.value == null) {
      logger.w("Cannot update like count: tweet not loaded");
      return;
    }

    state = AsyncData(
      state.value!.copyWith(
        likeCountUpdated: count,
      ),
    );
  }

  void _onRepostUpdate(int count) {
    logger.i("Received repost update: $count through socket on tweet id ${state.value?.tweet.value?.id ?? 'unknown'}");
  
    if (state.value == null || !state.value!.tweet.hasValue || state.value!.tweet.value == null) {
      logger.w("Cannot update repost count: tweet not loaded");
      return;
    }
    state = AsyncData(
      state.value!.copyWith(
        repostCountUpdated: count,
      ),
    );  
  }

  void _onCommentUpdate(int count) {
    logger.i("Received comment update: $count through socket on tweet id ${state.value?.tweet.value?.id ?? 'unknown'}");
    if (state.value == null || !state.value!.tweet.hasValue || state.value!.tweet.value == null) {
      logger.w("Cannot update comment count: tweet not loaded");
      return;
    }
    state = AsyncData(
      state.value!.copyWith(
        commentCountUpdated: count,
      ),
    );
  }

  //  Handle Like toggle
  Future<void> handleLike({required AnimationController controller}) async {
    // Get current state
    if (!state.hasValue || state.value == null) {
      print('⚠️ Cannot toggle like: state not loaded');
      return;
    }

    final currentState = state.value!;
    if (!currentState.tweet.hasValue || currentState.tweet.value == null) {
      print('⚠️ Cannot toggle like: tweet not loaded');
      return;
    }

    final currentTweet = currentState.tweet.value!;
    final currentIsLiked = currentState.isLiked;

    // Trigger animation immediately
    controller.forward().then((_) => controller.reverse());

    // Toggle state optimistically for instant UI feedback
    final newIsLiked = !currentIsLiked;
    final newCount = newIsLiked
        ? currentTweet.likes + 1
        : (currentTweet.likes > 0 ? currentTweet.likes - 1 : 0);

    // Update state immediately
    state = AsyncData(
      currentState.copyWith(
        isLiked: newIsLiked,
        tweet: AsyncData(currentTweet.copyWith(likes: newCount)),
      ),
    );

    print('💚 Optimistic like update: isLiked=$newIsLiked, count=$newCount');

    // Sync with backend
    try {
      final interactionsService = ref.read(postInteractionsServiceProvider);

      // Toggle like on backend
      final backendIsLiked = await interactionsService.toggleLike(
        currentTweet.id,
      );

      // Fetch actual count from backend
      final actualCount = await interactionsService.getLikesCount(
        currentTweet.id,
      );

      // Update stored interaction flags in the service
      final apiService = ref.read(tweetsApiServiceProvider);
      apiService.updateInteractionFlag(
        currentTweet.id,
        'isLikedByMe',
        backendIsLiked,
      );

      // Update with backend data
      state = AsyncData(
        currentState.copyWith(
          isLiked: backendIsLiked,
          tweet: AsyncData(currentTweet.copyWith(likes: actualCount)),
        ),
      );

      print(
        '✅ Backend like synced: isLiked=$backendIsLiked, count=$actualCount',
      );
    } catch (e) {
      print('❌ Error syncing like with backend: $e');
      // Revert to original state on error
      state = AsyncData(
        currentState.copyWith(
          isLiked: currentIsLiked,
          tweet: AsyncData(currentTweet),
        ),
      );
    }
  }

  // Handle Repost toggle
  Future<void> handleRepost({
    required AnimationController controllerRepost,
  }) async {
    // Get current state
    if (!state.hasValue || state.value == null) {
      print('⚠️ Cannot toggle repost: state not loaded');
      return;
    }

    final currentState = state.value!;
    if (!currentState.tweet.hasValue || currentState.tweet.value == null) {
      print('⚠️ Cannot toggle repost: tweet not loaded');
      return;
    }

    final currentTweet = currentState.tweet.value!;
    final currentIsReposted = currentState.isReposted;

    // Trigger animation immediately
    controllerRepost.forward().then((_) => controllerRepost.reverse());

    // Toggle state optimistically for instant UI feedback
    final newIsReposted = !currentIsReposted;
    final newCount = newIsReposted
        ? currentTweet.repost + 1
        : (currentTweet.repost > 0 ? currentTweet.repost - 1 : 0);

    // Update state immediately
    state = AsyncData(
      currentState.copyWith(
        isReposted: newIsReposted,
        tweet: AsyncData(currentTweet.copyWith(repost: newCount)),
      ),
    );

    print(
      '🔁 Optimistic repost update: isReposted=$newIsReposted, count=$newCount',
    );

    // Sync with backend
    try {
      final interactionsService = ref.read(postInteractionsServiceProvider);

      // Toggle repost on backend
      final backendIsReposted = await interactionsService.toggleRepost(
        currentTweet.id,
      );

      // Fetch actual count from backend
      final actualCount = await interactionsService.getRepostsCount(
        currentTweet.id,
      );

      // Update stored interaction flags in the service
      final apiService = ref.read(tweetsApiServiceProvider);
      apiService.updateInteractionFlag(
        currentTweet.id,
        'isRepostedByMe',
        backendIsReposted,
      );

      // Update with backend data
      state = AsyncData(
        currentState.copyWith(
          isReposted: backendIsReposted,
          tweet: AsyncData(currentTweet.copyWith(repost: actualCount)),
        ),
      );

      print(
        '✅ Backend repost synced: isReposted=$backendIsReposted, count=$actualCount',
      );
    } catch (e) {
      print('❌ Error syncing repost with backend: $e');
      // Revert to original state on error
      state = AsyncData(
        currentState.copyWith(
          isReposted: currentIsReposted,
          tweet: AsyncData(currentTweet),
        ),
      );
    }
  }

  // Format large numbers (K, M, B)
  String howLong(double m) {
    String s = '';
    if (m >= 1_000_000_000) {
      s = 'B';
      m /= 1_000_000_000;
    } else if (m >= 1_000_000) {
      s = 'M';
      m /= 1_000_000;
    } else if (m >= 1_000) {
      s = 'K';
      m /= 1_000;
    }

    String formatted = (m % 1 == 0)
        ? m.toInt().toString()
        : m.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    return '$formatted$s';
  }

  Future<void> handleViews() async {
    // Views are currently provided by the backend only (if available).
    // Do not modify them locally to avoid counts changing back after reload.

    // Ensure state and tweet are loaded
    if (!state.hasValue || state.value == null) {
      print('⚠️ Cannot handle views: state not loaded');
      return;
    }

    final currentState = state.value!;
    if (!currentState.tweet.hasValue || currentState.tweet.value == null) {
      print('⚠️ Cannot handle views: tweet not loaded');
      return;
    }

    // If already marked as viewed for this user, do nothing
    if (currentState.isViewed) {
      print('ℹ️ Views already recorded for this tweet, skipping increment');
      return;
    }

    final currentTweet = currentState.tweet.value!;
    final currentViews = currentTweet.views;
    final updatedViews = currentViews + 1;

    final updatedTweet = currentTweet.copyWith(views: updatedViews);

    // Optimistically update local state
    state = AsyncData(
      currentState.copyWith(isViewed: true, tweet: AsyncData(updatedTweet)),
    );

    try {
      // Persist updated views to backend (if endpoint exists)
      final repo = ref.read(tweetRepositoryProvider);
      await repo.updateTweet(updatedTweet);

      print(
        '👁️  View recorded on backend: $updatedViews views for tweet ${currentTweet.id}',
      );
    } catch (e) {
      // If backend does not yet support updating views, keep the optimistic value
      print('❌ Error updating views on backend (keeping local value): $e');
    }

    // Store interaction flag so we don't increment again on next open
    final apiService = ref.read(tweetsApiServiceProvider);
    apiService.updateInteractionFlag(currentTweet.id, 'isViewedByMe', true);
    // Persist local views override so views don't drop after refresh/restart
    apiService.setLocalViews(currentTweet.id, updatedViews);
  }

  void summarizeBody() {
    // TODO: implement tweet summarization
  }
  void handleShare() {}
  void handleBookmark() {}
  bool getIsLiked() {
    return state.value!.isLiked;
  }

  bool getisReposted() {
    return state.value!.isReposted;
  }

  Future<String> getSummary(String tweetId) async {
    return ref.read(tweetRepositoryProvider).getTweetSummery(tweetId);
  }
}
