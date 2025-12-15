import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'add_tweet_api_service.dart';

/// Real implementation of AddTweetApiService
/// Sends tweet with media files to backend in a single multipart request with authentication
class AddTweetApiServiceImpl implements AddTweetApiService {
  final ApiService _apiService;
  
  AddTweetApiServiceImpl({required ApiService apiService}) 
      : _apiService = apiService;
  
  @override
  Future<TweetModel> createTweet({
    required int userId,
    required String content,
    List<String>? mediaPicPaths,
    String? mediaVideoPath,
    String type = 'POST',
    int? parentPostId,
    List<int>? mentionsIds,
  }) async {
    try {
      print('📤 Creating tweet on backend...');
      print('   User ID: $userId');
      print('   Content: $content');
      print('   Image Paths: ${mediaPicPaths ?? const []}');
      print('   Video Path: ${mediaVideoPath ?? "None"}');
      
      // Prepare form data with required fields
      // Parse userId safely - if it's not a valid integer, default to 1

      
      // Create FormData with fields first
      final Map<String, dynamic> formFields = {
        'userId': userId, // Send as integer, not string
        'content': content,
        'type': type,
        'visibility': 'EVERY_ONE',
      };

      // Only include parentId when this is a reply/quote
      if (parentPostId != null) {
        formFields['parentId'] = parentPostId;
      }

      // Optional array of user IDs to mention (backend expects JSON string)
      if (mentionsIds != null && mentionsIds.isNotEmpty) {
        formFields['mentionsIds'] = jsonEncode(mentionsIds);
      }

      final formData = FormData.fromMap(formFields);
      
      // Add media files if they exist (as binary files, not URLs)
      if (mediaPicPaths != null && mediaPicPaths.isNotEmpty) {
        for (final path in mediaPicPaths.take(4)) {
          final file = File(path);
          if (await file.exists()) {
            // Detect MIME type from file
            final mimeType = lookupMimeType(path);
            final fileName = path.split(Platform.pathSeparator).last;

            print('   📷 Adding image file:');
            print('      Path: $path');
            print('      Filename: $fileName');
            print('      MIME type: $mimeType');
            print('      File size: ${await file.length()} bytes');

            // Create multipart file with proper content type
            final multipartFile = await MultipartFile.fromFile(
              path,
              filename: fileName,
              contentType:
                  mimeType != null ? MediaType.parse(mimeType) : null,
            );

            formData.files.add(MapEntry('media', multipartFile));
            print('   ✅ Image file added to request as BINARY data');
          } else {
            print('   ⚠️ Image file not found: $path');
          }
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
      print('   🌐 Sending request to backend:');
      print('      URL: ${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}');
      print('   📦 Request data:');
      print('      content: $content');
      print('      type: $type');
      if (parentPostId != null) {
        print('      parentId: $parentPostId');
      }
      print('      visibility: EVERY_ONE');
      print('      media files: ${formData.files.length}');
      
      // Always send as multipart/form-data when using FormData
      // Use ApiService's post method for multipart requests
      final responseMap = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          // Ensure cookies are included on web (CORS) requests
          extra: {'withCredentials': true},
        ),
      );
      
      print('✅ Tweet created successfully on backend!');
      
      // Parse response to get the created tweet with media URLs
      final responseData = responseMap['data'];
      print('   Response data: $responseData');

      // Prefer the new transformed post shape used by the backend
      // (TransformedPost / FeedPostDto) which matches TweetModel.fromJsonPosts.
      if (responseData is Map<String, dynamic>) {
        try {
          if (responseData.containsKey('postId') &&
              responseData.containsKey('date')) {
            final tweet = TweetModel.fromJsonPosts(responseData);
            print('   Parsed tweet from transformed post shape (postId=${tweet.id}).');
            return tweet;
          }
        } catch (e) {
          print('⚠️ Failed to parse createTweet response via fromJsonPosts, falling back: $e');
        }
      }

      // Legacy / fallback mapping for older backend shapes that return a
      // plain post object with id/user_id/content/created_at and media/mediaUrls.
      if (responseData is! Map) {
        throw StateError('Unexpected createTweet response format: $responseData');
      }

      final legacy = responseData as Map<String, dynamic>;

      // Parse media from backend - supporting multiple legacy formats
      final imageUrls = <String>[];
      final videoUrls = <String>[];

      // Format 1: media array with type info (preferred legacy shape)
      if (legacy['media'] != null && legacy['media'] is List) {
        final mediaArray = legacy['media'] as List;
        print('   📷 Legacy media array found: ${mediaArray.length} items');

        for (final mediaItem in mediaArray) {
          if (mediaItem is! Map) continue;
          final url = (mediaItem['media_url'] ?? mediaItem['url'])?.toString();
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
      // Format 2: mediaUrls array (very old fallback)
      else if (legacy['mediaUrls'] != null && legacy['mediaUrls'] is List) {
        final mediaUrls = legacy['mediaUrls'] as List;
        print('   📷 Legacy mediaUrls in response: ${mediaUrls.length} items');

        for (int i = 0; i < mediaUrls.length; i++) {
          final url = mediaUrls[i]?.toString();
          print('      - URL $i: $url');

          if (url != null && url.isNotEmpty) {
            // Simple heuristic: check file extension
            final lowerUrl = url.toLowerCase();
            if (lowerUrl.endsWith('.mp4') ||
                lowerUrl.endsWith('.mov') ||
                lowerUrl.endsWith('.avi') ||
                lowerUrl.endsWith('.webm') ||
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
        id: legacy['id']?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        userId: legacy['user_id']?.toString() ?? userId.toString(),
        body: legacy['content'] ?? content,
        date: legacy['created_at'] != null
            ? DateTime.parse(legacy['created_at'])
            : DateTime.now(),
        likes: legacy['likes'] ?? 0,
        repost: legacy['repost'] ?? 0,
        comments: legacy['comments'] ?? 0,
        views: legacy['views'] ?? 0,
        qoutes: legacy['qoutes'] ?? 0,
        bookmarks: legacy['bookmarks'] ?? 0,
        mediaImages: imageUrls,
        mediaVideos: videoUrls,
      );

      print('   Created tweet ID (legacy): ${createdTweet.id}');
      print('   Media Images: ${createdTweet.mediaImages.length} items');
      print('   Media Videos: ${createdTweet.mediaVideos.length} items');

      return createdTweet;
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
final addTweetApiServiceProvider = Provider<AddTweetApiService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AddTweetApiServiceImpl(apiService: apiService);
});
