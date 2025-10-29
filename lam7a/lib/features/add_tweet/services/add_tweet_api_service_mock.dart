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
    
    // Simulate network delay (matching main service logic)
    await _simulateNetworkDelay();
    
    // Generate mock URLs for media files - supporting multiple images and videos
    final mockImageUrls = <String>[];
    final mockVideoUrls = <String>[];
    
    if (mediaPicPath != null && mediaPicPath.isNotEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Generate multiple mock images (simulating backend behavior)
      mockImageUrls.add('https://picsum.photos/seed/$timestamp-1/800/600');
      mockImageUrls.add('https://picsum.photos/seed/$timestamp-2/800/600');
      mockImageUrls.add('https://picsum.photos/seed/$timestamp-3/800/600');
      print('   📷 Generated ${mockImageUrls.length} mock image URLs');
      for (int i = 0; i < mockImageUrls.length; i++) {
        print('      - Image $i: ${mockImageUrls[i]}');
      }
    }
    
    if (mediaVideoPath != null && mediaVideoPath.isNotEmpty) {
      // Generate multiple mock videos (simulating backend behavior)
      mockVideoUrls.add('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
      mockVideoUrls.add('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
      print('   🎥 Generated ${mockVideoUrls.length} mock video URLs');
      for (int i = 0; i < mockVideoUrls.length; i++) {
        print('      - Video $i: ${mockVideoUrls[i]}');
      }
    }
    
    // Create and return the mock tweet (matching backend response structure)
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
      mediaImages: mockImageUrls,
      mediaVideos: mockVideoUrls,
    );
    
    print('✅ [MOCK] Tweet created successfully!');
    print('   Tweet ID: ${mockTweet.id}');
    print('   Media Images: ${mockTweet.mediaImages.length} items');
    print('   Media Videos: ${mockTweet.mediaVideos.length} items');
    
    return mockTweet;
  }
}
