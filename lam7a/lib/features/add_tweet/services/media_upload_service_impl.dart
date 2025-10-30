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
      
      // Upload to backend using ApiService's Dio instance
      final response = await _apiService.dio.post(
        '/upload/image', // Adjust endpoint as needed
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final imageUrl = response.data['data']['url'] as String;
        print('✅ Image uploaded successfully! URL: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
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
      
      // Upload to backend using ApiService's Dio instance
      final response = await _apiService.dio.post(
        '/upload/video', // Adjust endpoint as needed
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final videoUrl = response.data['data']['url'] as String;
        print('✅ Video uploaded successfully! URL: $videoUrl');
        return videoUrl;
      } else {
        throw Exception('Failed to upload video: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error uploading video: $e');
      rethrow;
    }
  }
}

/// Provider for MediaUploadService with ApiService
final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MediaUploadServiceImpl(apiService: apiService);
});
