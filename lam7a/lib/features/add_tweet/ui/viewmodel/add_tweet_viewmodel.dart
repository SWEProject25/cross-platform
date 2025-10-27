import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/services/media_upload_service_mock.dart';
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
  Future<void> postTweet(String userId) async {
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

      final uploadService = ref.read(mediaUploadServiceProvider);
      final repo = ref.read(tweetRepositoryProvider);
      
      // Upload media files if they exist and get URLs
      String? mediaPicUrl;
      String? mediaVideoUrl;
      
      if (state.mediaPicPath != null) {
        print('📸 Uploading image...');
        mediaPicUrl = await uploadService.uploadImage(state.mediaPicPath!);
      }
      
      if (state.mediaVideoPath != null) {
        print('🎥 Uploading video...');
        mediaVideoUrl = await uploadService.uploadVideo(state.mediaVideoPath!);
      }
      
      final newTweet = TweetModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        body: state.body.trim(),
        mediaPic: mediaPicUrl, // Now using URL instead of local path
        mediaVideo: mediaVideoUrl, // Now using URL instead of local path
        date: DateTime.now(),
        likes: 0,
        qoutes: 0,
        bookmarks: 0,
        repost: 0,
        comments: 0,
        views: 0,
        userId: userId,
      );

      print('📝 Tweet prepared:');
      print('   Body: ${newTweet.body}');
      print('   Media Pic URL: ${newTweet.mediaPic ?? "None"}');
      print('   Media Video URL: ${newTweet.mediaVideo ?? "None"}');
      
      await repo.addTweet(newTweet);

      print('✅ Tweet posted successfully via repository!');
      
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
