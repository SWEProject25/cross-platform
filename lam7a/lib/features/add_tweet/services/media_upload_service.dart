/// Interface for media upload service
abstract class MediaUploadService {
  /// Upload an image and return the URL
  Future<String> uploadImage(String localPath);
  
  /// Upload a video and return the URL
  Future<String> uploadVideo(String localPath);
}
