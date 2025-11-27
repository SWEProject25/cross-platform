import 'package:lam7a/features/common/models/tweet_model.dart';

/// Service interface for adding tweets with media
abstract class AddTweetApiService {
  /// Create a new tweet/post with optional media files
  /// 
  /// [userId] - The ID of the user creating the post
  /// [content] - The text content of the tweet
  /// [mediaPicPath] - Optional local file path for an image
  /// [mediaVideoPath] - Optional local file path for a video
  /// [type] - The type of post (POST, REPLY, QUOTE). Defaults to POST.
  /// [parentPostId] - Optional parent post ID when this is a reply or quote
  /// 
  /// Returns the created tweet with media URLs populated by the backend
  Future<TweetModel> createTweet({
    required int userId,
    required String content,
    List<String>? mediaPicPaths,
    String? mediaVideoPath,
    String type = 'POST',
    int? parentPostId,
  });
}
