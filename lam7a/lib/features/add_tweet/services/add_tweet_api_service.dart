import 'package:lam7a/features/common/models/tweet_model.dart';

/// Service interface for adding tweets with media
abstract class AddTweetApiService {
  /// Create a new tweet/post with optional media files
  /// 
  /// [userId] - The ID of the user creating the post
  /// [content] - The text content of the tweet
  /// [mediaPicPath] - Optional local file path for an image
  /// [mediaVideoPath] - Optional local file path for a video
  /// 
  /// Returns the created tweet with media URLs populated by the backend
  Future<TweetModel> createTweet({
    required String userId,
    required String content,
    String? mediaPicPath,
    String? mediaVideoPath,
  });
}
