import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'add_tweet_api_service.dart';

/// Real implementation of AddTweetApiService
/// Sends tweet with media files to backend in a single multipart request
class AddTweetApiServiceImpl implements AddTweetApiService {
  final Dio _dio;
  
  AddTweetApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: ApiConfig.currentBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
    ),
  );
  
  @override
  Future<TweetModel> createTweet({
    required String userId,
    required String content,
    String? mediaPicPath,
    String? mediaVideoPath,
  }) async {
    try {
      print('📤 Creating tweet on backend...');
      print('   User ID: $userId');
      print('   Content: $content');
      print('   Image Path: ${mediaPicPath ?? "None"}');
      print('   Video Path: ${mediaVideoPath ?? "None"}');
      
      // Prepare form data with required fields
      // Parse userId safely - if it's not a valid integer, default to 1
      int userIdInt = 1;
      try {
        userIdInt = int.parse(userId);
      } catch (e) {
        print('   ⚠️ Invalid userId format: $userId, using default ID: 1');
        userIdInt = 1;
      }
      
      final formData = FormData.fromMap({
        'userId': userIdInt,
        'content': content,
        'type': 'POST',
        'visibility': 'EVERY_ONE',
      });
      
      // Add media files if they exist (as binary files, not URLs)
      if (mediaPicPath != null && mediaPicPath.isNotEmpty) {
        final file = File(mediaPicPath);
        if (await file.exists()) {
          // Detect MIME type from file
          final mimeType = lookupMimeType(mediaPicPath);
          final fileName = mediaPicPath.split(Platform.pathSeparator).last;
          
          print('   📷 Adding image file:');
          print('      Path: $mediaPicPath');
          print('      Filename: $fileName');
          print('      MIME type: $mimeType');
          print('      File size: ${await file.length()} bytes');
          
          // Create multipart file with proper content type
          final multipartFile = await MultipartFile.fromFile(
            mediaPicPath,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          );
          
          formData.files.add(MapEntry('mediaFiles', multipartFile));
          print('   ✅ Image file added to request as BINARY data');
        } else {
          print('   ⚠️ Image file not found: $mediaPicPath');
        }
      }
      
      if (mediaVideoPath != null && mediaVideoPath.isNotEmpty) {
        final file = File(mediaVideoPath);
        if (await file.exists()) {
          // Detect MIME type from file
          final mimeType = lookupMimeType(mediaVideoPath);
          final fileName = mediaVideoPath.split(Platform.pathSeparator).last;
          
          print('   🎥 Adding video file:');
          print('      Path: $mediaVideoPath');
          print('      Filename: $fileName');
          print('      MIME type: $mimeType');
          print('      File size: ${await file.length()} bytes');
          
          // Create multipart file with proper content type
          final multipartFile = await MultipartFile.fromFile(
            mediaVideoPath,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          );
          
          formData.files.add(MapEntry('mediaFiles', multipartFile));
          print('   ✅ Video file added to request as BINARY data');
        } else {
          print('   ⚠️ Video file not found: $mediaVideoPath');
        }
      }
      
      // Send request to backend
      print('   🌐 Sending multipart/form-data request to:');
      print('      ${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}');
      print('   📦 Form data fields:');
      print('      userId: $userIdInt (integer)');
      print('      content: $content');
      print('      type: POST');
      print('      visibility: EVERY_ONE');
      print('      mediaFiles: ${formData.files.length} file(s)');
      
      final response = await _dio.post(
        ApiConfig.postsEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Tweet created successfully on backend!');
        
        // Parse response to get the created tweet with media URLs
        final responseData = response.data['data'];
        print('   Response data: $responseData');
        
        // Create TweetModel from response
        // The backend returns the post with media URLs already populated
        final createdTweet = TweetModel(
          id: responseData['postId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          body: content,
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          // Media URLs returned by backend
          mediaPic: responseData['media'] != null && (responseData['media'] as List).isNotEmpty
              ? responseData['media'][0]['url'] as String?
              : null,
          mediaVideo: responseData['media'] != null && (responseData['media'] as List).length > 1
              ? responseData['media'][1]['url'] as String?
              : null,
        );
        
        print('   Created tweet ID: ${createdTweet.id}');
        print('   Media Pic URL: ${createdTweet.mediaPic ?? "None"}');
        print('   Media Video URL: ${createdTweet.mediaVideo ?? "None"}');
        
        return createdTweet;
      } else {
        throw Exception('Failed to create tweet: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error creating tweet:');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Message: ${e.message}');
      print('   Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Error creating tweet: $e');
      rethrow;
    }
  }
}

/// Provider for AddTweetApiService (real implementation)
final addTweetApiServiceProvider = Provider<AddTweetApiService>((ref) {
  return AddTweetApiServiceImpl();
});
