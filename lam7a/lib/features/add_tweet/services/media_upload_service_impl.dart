import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'media_upload_service.dart';

/// Real implementation of media upload service
/// Uploads files to the backend server with authentication
class MediaUploadServiceImpl implements MediaUploadService {
  final ApiService _apiService;
  
  MediaUploadServiceImpl({required ApiService apiService}) 
      : _apiService = apiService;
  
  @override
  Future<String> uploadImage(String localPath) async {
    try {
      print('📤 Uploading image to backend: $localPath');
      
      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('File not found: $localPath');
      }
      
      // Create multipart file from the local file
      final fileName = localPath.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        localPath,
        filename: fileName,
      );
      
      // Create form data with the file
      final formData = FormData.fromMap({
        'image': multipartFile,
      });
      
      // Upload to backend using ApiService's post method
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/upload/image', // Adjust endpoint as needed
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      final imageUrl = response['data']['url'] as String;
      print('✅ Image uploaded successfully! URL: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('❌ Error uploading image: $e');
      rethrow;
    }
  }
  
  @override
  Future<String> uploadVideo(String localPath) async {
    try {
      print('📤 Uploading video to backend: $localPath');
      
      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('File not found: $localPath');
      }
      
      // Create multipart file from the local file
      final fileName = localPath.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        localPath,
        filename: fileName,
      );
      
      // Create form data with the file
      final formData = FormData.fromMap({
        'video': multipartFile,
      });
      
      // Upload to backend using ApiService's post method
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/upload/video', // Adjust endpoint as needed
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      final videoUrl = response['data']['url'] as String;
      print('✅ Video uploaded successfully! URL: $videoUrl');
      return videoUrl;
    } catch (e) {
      print('❌ Error uploading video: $e');
      rethrow;
    }
  }
}

/// Provider for MediaUploadService with ApiService
final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return MediaUploadServiceImpl(apiService: apiService);
});
