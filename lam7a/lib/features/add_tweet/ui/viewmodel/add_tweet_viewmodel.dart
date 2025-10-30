import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/core/providers/authentication.dart';
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
  void updateMediaPic(String? path) {
    state = state.copyWith(mediaPicPath: path);
  }

  // Update media video path
  void updateMediaVideo(String? path) {
    state = state.copyWith(mediaVideoPath: path);
  }

  // Remove media pic
  void removeMediaPic() {
    state = state.copyWith(mediaPicPath: null);
  }

  // Remove media video
  void removeMediaVideo() {
    state = state.copyWith(mediaVideoPath: null);
  }

  // Check if the tweet can be posted
  bool canPostTweet() {
    return state.isValidBody && !state.isLoading;
  }

  // Post the tweet
  Future<void> postTweet() async {
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
      
      // Get user ID - fallback to '1' if not authenticated (for testing)
      // In production, you should enforce authentication
      String userId;
      if (user == null || user.userId == null) {
        print('⚠️ User not authenticated, using default ID: 1');
        print('   Note: In production, you should redirect to login');
        userId = '1'; // Fallback for testing
      } else {
        userId = user.userId!;
        print('✅ Using authenticated user ID: $userId');
      }

      // Use real backend implementation with authentication
      final apiService = ref.read(addTweetApiServiceProvider);
      
      // Create tweet with media files (service handles upload and returns URLs)
      final createdTweet = await apiService.createTweet(
        userId: userId,
        content: state.body.trim(),
        mediaPicPath: state.mediaPicPath,
        mediaVideoPath: state.mediaVideoPath,
      );

      print('📝 Tweet created:');
      print('   ID: ${createdTweet.id}');
      print('   Body: ${createdTweet.body}');
      print('   Media Pic URL: ${createdTweet.mediaPic ?? "None"}');
      print('   Media Video URL: ${createdTweet.mediaVideo ?? "None"}');
      
      // Note: Backend already persisted the tweet, no need to call repository again
      // The repository's addTweet would make a duplicate backend call

      print('✅ Tweet posted successfully!');
      
      state = state.copyWith(
        isLoading: false,
        isTweetPosted: true,
      );
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
