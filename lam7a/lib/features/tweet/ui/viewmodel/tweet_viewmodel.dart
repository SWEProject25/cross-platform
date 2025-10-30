import 'package:flutter/animation.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_viewmodel.g.dart';

@riverpod
class TweetViewModel extends _$TweetViewModel {

@override
FutureOr<TweetState> build(String tweetId) async {
  final repo = ref.read(tweetRepositoryProvider);
  final tweet = await repo.fetchTweetById(tweetId);
  
  // Initialize interaction state
  // Note: Backend doesn't provide isLikedByCurrentUser or isRepostedByCurrentUser
  // So we always start with false. State will update when user interacts.
  // See BACKEND_REQUIREMENT.md for the proper solution.
  bool isLiked = false;
  bool isReposted = false;
  
  print('📊 Initializing tweet state for: $tweetId');
  print('   Likes: ${tweet.likes}, Reposts: ${tweet.repost}');
  print('   ⚠️ isLiked/isReposted initialized to false (backend limitation)');

  return TweetState(
    isLiked: isLiked,
    isReposted: isReposted,
    isViewed: false,
    tweet: AsyncData(tweet),
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
    final newCount = newIsLiked ? currentTweet.likes + 1 : (currentTweet.likes > 0 ? currentTweet.likes - 1 : 0);
    
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
      final backendIsLiked = await interactionsService.toggleLike(currentTweet.id);
      
      // Fetch actual count from backend
      final actualCount = await interactionsService.getLikesCount(currentTweet.id);
      
      // Update with backend data
      state = AsyncData(
        currentState.copyWith(
          isLiked: backendIsLiked,
          tweet: AsyncData(currentTweet.copyWith(likes: actualCount)),
        ),
      );
      
      print('✅ Backend like synced: isLiked=$backendIsLiked, count=$actualCount');
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
  Future<void> handleRepost({required AnimationController controllerRepost}) async {
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
    final newCount = newIsReposted ? currentTweet.repost + 1 : (currentTweet.repost > 0 ? currentTweet.repost - 1 : 0);
    
    // Update state immediately
    state = AsyncData(
      currentState.copyWith(
        isReposted: newIsReposted,
        tweet: AsyncData(currentTweet.copyWith(repost: newCount)),
      ),
    );
    
    print('🔁 Optimistic repost update: isReposted=$newIsReposted, count=$newCount');
    
    // Sync with backend
    try {
      final interactionsService = ref.read(postInteractionsServiceProvider);
      
      // Toggle repost on backend
      final backendIsReposted = await interactionsService.toggleRepost(currentTweet.id);
      
      // Fetch actual count from backend
      final actualCount = await interactionsService.getRepostsCount(currentTweet.id);
      
      // Update with backend data
      state = AsyncData(
        currentState.copyWith(
          isReposted: backendIsReposted,
          tweet: AsyncData(currentTweet.copyWith(repost: actualCount)),
        ),
      );
      
      print('✅ Backend repost synced: isReposted=$backendIsReposted, count=$actualCount');
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
    final current = state.value!;
    final tweet = state.value!.tweet.value!;
    
    if (!current.isViewed) {
      // Update local state immediately (views are typically not synced to backend)
      final updated = tweet.copyWith(views: tweet.views + 1);
      final updatedState = current.copyWith(tweet: AsyncData(updated), isViewed: true);
      state = AsyncData(updatedState);
      
      // Note: Backend doesn't have a view tracking endpoint yet
      // If backend adds view tracking, call it here
    }
  }

  void handleComment() {
    // TODO: add comment logic
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
}
