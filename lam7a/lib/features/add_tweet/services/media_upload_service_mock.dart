import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'media_upload_service.dart';

part 'media_upload_service_mock.g.dart';

/// Mock implementation of media upload service
/// Simulates uploading and returns mock URLs
class MediaUploadServiceMock implements MediaUploadService {
  
  /// Simulate network delay
  Future<void> _simulateUpload() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
  
  @override
  Future<String> uploadImage(String localPath) async {
    print('📤 Uploading image: $localPath');
    await _simulateUpload();
    
    // Generate a mock URL based on timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final mockUrl = 'https://picsum.photos/seed/$timestamp/800/600';
    
    print('✅ Image uploaded! URL: $mockUrl');
    return mockUrl;
  }
  
  @override
  Future<String> uploadVideo(String localPath) async {
    print('📤 Uploading video: $localPath');
    await _simulateUpload();
    
    // Return a mock video URL (using Flutter's sample video)
    final mockUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    
    print('✅ Video uploaded! URL: $mockUrl');
    return mockUrl;
  }
}

/// Provider for media upload service
@riverpod
MediaUploadService mediaUploadService(Ref ref) {
  return MediaUploadServiceMock();
}
