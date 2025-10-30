import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/api/authenticated_dio_provider.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'add_tweet_api_service.dart';

/// Real implementation of AddTweetApiService
/// Sends tweet with media files to backend in a single multipart request with authentication
class AddTweetApiServiceImpl implements AddTweetApiService {
  final Dio _dio;
  
  AddTweetApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio() {
    if (dio == null) {
      print('⚠️ AddTweetApiServiceImpl: Using non-authenticated Dio. Use createAuthenticated() for auth.');
    }
  }
  
  /// Factory constructor to create with authenticated Dio
  static Future<AddTweetApiServiceImpl> createAuthenticated() async {
    final dio = await createAuthenticatedDio();
    return AddTweetApiServiceImpl(dio: dio);
  }
  
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
      
      // Create FormData with fields first
      final formData = FormData.fromMap({
        'userId': userIdInt, // Send as integer, not string
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
          
          formData.files.add(MapEntry('media', multipartFile));
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
          
          formData.files.add(MapEntry('media', multipartFile));
          print('   ✅ Video file added to request as BINARY data');
        } else {
          print('   ⚠️ Video file not found: $mediaVideoPath');
        }
      }
      
      // Send request to backend - always use multipart if we have form data structure
      final Response response;
      
      print('   🌐 Sending request to backend:');
      print('      URL: ${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}');
      print('   📦 Request data:');
      print('      content: $content');
      print('      type: POST');
      print('      visibility: EVERY_ONE');
      print('      media files: ${formData.files.length}');
      
      // Always send as multipart/form-data when using FormData
      response = await _dio.post(
        ApiConfig.postsEndpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          // Ensure cookies are included on web (CORS) requests
          extra: {'withCredentials': true},
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Tweet created successfully on backend!');
        
        // Parse response to get the created tweet with media URLs
        final responseData = response.data['data'];
        print('   Response data: $responseData');
        
        // Create TweetModel from response
        // The backend returns the post with field names: id, user_id, content, created_at
        
        // Parse media from backend - supporting multiple formats
        final imageUrls = <String>[];
        final videoUrls = <String>[];
        
        // Format 1: media array with type info (preferred)
        if (responseData['media'] != null && responseData['media'] is List) {
          final mediaArray = responseData['media'] as List;
          print('   📷 Media array found: ${mediaArray.length} items');
          
          for (final mediaItem in mediaArray) {
            final url = mediaItem['media_url']?.toString();
            final type = mediaItem['type']?.toString();
            
            if (url != null && url.isNotEmpty) {
              print('      - URL: $url (type: $type)');
              if (type == 'VIDEO') {
                videoUrls.add(url);
                print('      ✅ Added to videos');
              } else {
                imageUrls.add(url);
                print('      ✅ Added to images');
              }
            }
          }
        }
        // Format 2: mediaUrls array (fallback)
        else if (responseData['mediaUrls'] != null && responseData['mediaUrls'] is List) {
          final mediaUrls = responseData['mediaUrls'] as List;
          print('   📷 MediaUrls in response: ${mediaUrls.length} items');
          
          for (int i = 0; i < mediaUrls.length; i++) {
            final url = mediaUrls[i]?.toString();
            print('      - URL $i: $url');
            
            if (url != null && url.isNotEmpty) {
              // Simple heuristic: check file extension
              final lowerUrl = url.toLowerCase();
              if (lowerUrl.endsWith('.mp4') || lowerUrl.endsWith('.mov') || 
                  lowerUrl.endsWith('.avi') || lowerUrl.endsWith('.webm') ||
                  lowerUrl.contains('video')) {
                videoUrls.add(url);
                print('      ✅ Added to videos');
              } else {
                imageUrls.add(url);
                print('      ✅ Added to images');
              }
            }
          }
        }
        
        final createdTweet = TweetModel(
          id: responseData['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          userId: responseData['user_id']?.toString() ?? userId,
          body: responseData['content'] ?? content,
          date: responseData['created_at'] != null 
              ? DateTime.parse(responseData['created_at']) 
              : DateTime.now(),
          likes: responseData['likes'] ?? 0,
          repost: responseData['repost'] ?? 0,
          comments: responseData['comments'] ?? 0,
          views: responseData['views'] ?? 0,
          qoutes: responseData['qoutes'] ?? 0,
          bookmarks: responseData['bookmarks'] ?? 0,
          mediaImages: imageUrls,
          mediaVideos: videoUrls,
        );
        
        print('   Created tweet ID: ${createdTweet.id}');
        print('   Media Images: ${createdTweet.mediaImages.length} items');
        print('   Media Videos: ${createdTweet.mediaVideos.length} items');
        
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

/// Provider for AddTweetApiService (real implementation with authentication)
final addTweetApiServiceProvider = FutureProvider<AddTweetApiService>((ref) async {
  final dio = await ref.watch(authenticatedDioProvider.future);
  return AddTweetApiServiceImpl(dio: dio);
});
