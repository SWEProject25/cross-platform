import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/user_new_tweets_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_tweet_viewmodel.g.dart';

@riverpod
class AddTweetViewmodel extends _$AddTweetViewmodel {
  static const int minBodyLength = 1;
  static const int maxBodyLength = 280;

  @override
  AddTweetState build() {
    return const AddTweetState();
  }

  // Update tweet body text
  void updateBody(String body) {
    state = state.copyWith(
      body: body,
      isValidBody: _validateBody(body),
      errorMessage: null,
    );
  }

  // Validate body text
  bool _validateBody(String body) {
    final trimmedBody = body.trim();
    return trimmedBody.isNotEmpty && 
           trimmedBody.length >= minBodyLength && 
           trimmedBody.length <= maxBodyLength;
  }

  // Update media pic path
  static const int maxMediaImages = 4;

  void addMediaPic(String path) {
    final current = List<String>.from(state.mediaPicPaths);
    if (current.length >= maxMediaImages) {
      return;
    }
    current.add(path);
    state = state.copyWith(mediaPicPaths: current);
  }

  // Update media video path
  void updateMediaVideo(String? path) {
    state = state.copyWith(mediaVideoPath: path);
  }

  // Remove media pic
  void removeMediaPicAt(int index) {
    final current = List<String>.from(state.mediaPicPaths);
    if (index < 0 || index >= current.length) {
      return;
    }
    current.removeAt(index);
    state = state.copyWith(mediaPicPaths: current);
  }

  // Remove media video
  void removeMediaVideo() {
    state = state.copyWith(mediaVideoPath: null);
  }

  // Check if the tweet can be posted
  bool canPostTweet() {
    return state.isValidBody && !state.isLoading;
  }

  // Configure this viewmodel to create a reply to a specific post
  void setReplyTo(int parentPostId) {
    state = state.copyWith(
      parentPostId: parentPostId,
      postType: 'REPLY',
    );
  }

  // Configure this viewmodel to create a quote of a specific post
  void setQuoteTo(int parentPostId) {
    state = state.copyWith(
      parentPostId: parentPostId,
      postType: 'QUOTE',
    );
  }

  // Post the tweet
  Future<void> postTweet({List<int>? mentionsIds}) async {
    if (!canPostTweet()) {
      print('⚠️ Cannot post tweet: validation failed');
      state = state.copyWith(
        errorMessage: "Please enter valid tweet content",
      );
      return;
    }

    try {
      print('📤 Starting to post tweet...');
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Get authenticated user from core provider
      final authState = ref.read(authenticationProvider);
      final user = authState.user;
      
      // Get user id - fallback to '1' if not authenticated (for testing)
      // In production, you should enforce authentication
     int id;
      if (user == null || user.id == null) {
        print('⚠️ User not authenticated, using default id: 1');
        print('   Note: In production, you should redirect to login');
        id = 1; // Fallback for testing
      } else {
        id = user.id!;
        print('✅ Using authenticated user id: $id');
      }

      // Use real backend implementation with authentication
      final apiService = ref.read(addTweetApiServiceProvider);
      
      // Create tweet or reply with media files (service handles upload and returns URLs)
      final createdTweet = await apiService.createTweet(
        userId: id,
        content: state.body.trim(),
        mediaPicPaths: state.mediaPicPaths,
        mediaVideoPath: state.mediaVideoPath,
        type: state.postType,
        parentPostId: state.parentPostId,
        mentionsIds: mentionsIds,
      );

      print('📝 Tweet created:');
      print('   userId: ${createdTweet.userId}');
      print('   Body: ${createdTweet.body}');
      print('   Media Pic URL: ${createdTweet.mediaPic ?? "None"}');
      print('   Media Video URL: ${createdTweet.mediaVideo ?? "None"}');
      
      var tweetForFeed = createdTweet;
      if (user != null) {
        tweetForFeed = createdTweet.copyWith(
          username: user.username,
          authorName: user.name ?? user.username,
          authorProfileImage: user.profileImageUrl,
        );
      }
      
      // Note: Backend already persisted the tweet, no need to call repository again
      // The repository's addTweet would make a duplicate backend call

      print('✅ Tweet posted successfully!');

      state = state.copyWith(
        isLoading: false,
        isTweetPosted: true,
      );

      // Always keep track of newly created tweets (including replies) in a
      // dedicated viewmodel so UI can listen to a provider of "my new tweets".
      final newTweetsVm = ref.read(userNewTweetsViewModelProvider.notifier);
      newTweetsVm.addTweet(tweetForFeed);

      // Only inject into the main home timeline for top-level posts and quotes.
      // Replies should stay scoped to the detailed tweet view (replies list),
      // so they are not shown as separate tweets on the home screen.
      if (state.postType == 'POST' || state.postType == 'QUOTE') {
        final homeVm = ref.read(tweetHomeViewModelProvider.notifier);
        homeVm.upsertTweetLocally(tweetForFeed);
      }
    } catch (e) {
      print('❌ Error posting tweet: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to post tweet: ${e.toString()}",
      );
    }
  }

  // Reset the state
  void reset() {
    state = const AddTweetState();
  }

  // Get character count
  int getCharacterCount() {
    return state.body.length;
  }

  // Get remaining characters
  int getRemainingCharacters() {
    return maxBodyLength - state.body.length;
  }
}
