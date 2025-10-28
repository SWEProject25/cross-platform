import 'package:lam7a/features/common/models/tweet_model.dart';
import 'add_tweet_api_service.dart';

/// Mock implementation of AddTweetApiService
/// Simulates backend behavior without making real network calls
class AddTweetApiServiceMock implements AddTweetApiService {
  
  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
  
  @override
  Future<TweetModel> createTweet({
    required String userId,
    required String content,
    String? mediaPicPath,
    String? mediaVideoPath,
  }) async {
    print('📤 [MOCK] Creating tweet...');
    print('   User ID: $userId');
    print('   Content: $content');
    print('   Image Path: ${mediaPicPath ?? "None"}');
    print('   Video Path: ${mediaVideoPath ?? "None"}');
    
    // Simulate network delay
    await _simulateNetworkDelay();
    
    // Generate mock URLs for media files
    String? mockImageUrl;
    String? mockVideoUrl;
    
    if (mediaPicPath != null && mediaPicPath.isNotEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      mockImageUrl = 'https://picsum.photos/seed/$timestamp/800/600';
      print('   📷 Generated mock image URL: $mockImageUrl');
    }
    
    if (mediaVideoPath != null && mediaVideoPath.isNotEmpty) {
      mockVideoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
      print('   🎥 Generated mock video URL: $mockVideoUrl');
    }
    
    // Create and return the mock tweet
    final mockTweet = TweetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      body: content,
      date: DateTime.now(),
      likes: 0,
      repost: 0,
      comments: 0,
      views: 0,
      qoutes: 0,
      bookmarks: 0,
      mediaPic: mockImageUrl,
      mediaVideo: mockVideoUrl,
    );
    
    print('✅ [MOCK] Tweet created successfully!');
    print('   Tweet ID: ${mockTweet.id}');
    print('   Media Pic URL: ${mockTweet.mediaPic ?? "None"}');
    print('   Media Video URL: ${mockTweet.mediaVideo ?? "None"}');
    
    return mockTweet;
  }
}
