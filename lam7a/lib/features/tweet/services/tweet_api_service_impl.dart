import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/api/authenticated_dio_provider.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';

/// Real implementation of Tweets API Service
/// Communicates with the backend server with authentication
class TweetsApiServiceImpl implements TweetsApiService {
  final Dio _dio;
  late final PostInteractionsService _interactionsService;
  
  TweetsApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio() {
    if (dio == null) {
      // If no Dio provided, we'll use the authenticated one
      print('⚠️ TweetsApiServiceImpl: Using non-authenticated Dio. Use createAuthenticatedDio() for auth.');
    }
    _interactionsService = PostInteractionsService(_dio);
  }
  
  /// Factory constructor to create with authenticated Dio
  static Future<TweetsApiServiceImpl> createAuthenticated() async {
    final dio = await createAuthenticatedDio();
    return TweetsApiServiceImpl(dio: dio);
  }
  
  @override
  Future<List<TweetModel>> getAllTweets() async {
    try {
      final url = '${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}';
      print('📥 Fetching all tweets from backend...');
      print('   URL: $url');
      
      final response = await _dio.get(ApiConfig.postsEndpoint);
      
      print('   Response status: ${response.statusCode}');
      print('   Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print('   Raw tweet data count: ${data.length}');
        
        final tweets = await Future.wait(data.map((json) async {
          print('   Processing tweet: ${json['id']}');
          
          // Map backend fields to frontend model
          final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
          
          final mappedJson = <String, dynamic>{
            'id': tweetId,
            'userId': (json['user_id'] ?? json['userId'])?.toString() ?? '0',
            'body': (json['content'] ?? json['body'] ?? '').toString(),
            'date': (json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString(),
          };
          
          // Parse mediaUrls array from backend - supporting multiple media
          final imageUrls = <String>[];
          final videoUrls = <String>[];
          
          if (json['mediaUrls'] != null && json['mediaUrls'] is List && (json['mediaUrls'] as List).isNotEmpty) {
            final mediaUrls = json['mediaUrls'] as List;
            print('   📷 MediaUrls found: ${mediaUrls.length} items');
            
            // TODO: Backend should return media with type information
            // For now, assume all URLs are images unless they have video extensions
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
            
            mappedJson['mediaImages'] = imageUrls;
            mappedJson['mediaVideos'] = videoUrls;
            print('   📊 Parsed: ${imageUrls.length} images, ${videoUrls.length} videos');
          }
          // Fallback to old field names if mediaUrls not present
          else {
            print('   ℹ️ No mediaUrls in response, checking old fields');
            if (json['mediaPic'] != null || json['media_pic'] != null) {
              final pic = json['mediaPic'] ?? json['media_pic'];
              imageUrls.add(pic);
              mappedJson['mediaPic'] = pic;
            }
            if (json['mediaVideo'] != null || json['media_video'] != null) {
              final video = json['mediaVideo'] ?? json['media_video'];
              videoUrls.add(video);
              mappedJson['mediaVideo'] = video;
            }
            mappedJson['mediaImages'] = imageUrls;
            mappedJson['mediaVideos'] = videoUrls;
          }
          
          // Fetch real counts from interaction endpoints (if available)
          // Backend may not have these endpoints yet (returns 404)
          try {
            final counts = await _interactionsService.getPostCounts(tweetId);
            mappedJson['likes'] = counts['likes'] ?? 0;
            mappedJson['repost'] = counts['reposts'] ?? 0;
          } catch (e) {
            // Silently use defaults if endpoints not available
            mappedJson['likes'] = 0;
            mappedJson['repost'] = 0;
          }
          
          return TweetModel.fromJson(mappedJson);
        }).toList());
        
        print('✅ Fetched ${tweets.length} tweets');
        return tweets;
      } else {
        throw Exception('Failed to fetch tweets: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching tweets: $e');
      rethrow;
    }
  }
  
  @override
  Future<TweetModel> getTweetById(String id) async {
    try {
      print('📥 Fetching tweet by ID: $id');
      
      final response = await _dio.get('${ApiConfig.postsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final json = response.data['data'];
        // Map backend fields to frontend model
        final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
        
        final mappedJson = <String, dynamic>{
          'id': tweetId,
          'userId': (json['user_id'] ?? json['userId'])?.toString() ?? '0',
          'body': (json['content'] ?? json['body'] ?? '').toString(),
          'date': (json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString(),
        };
        
        // Parse mediaUrls array from backend - supporting multiple media
        final imageUrls = <String>[];
        final videoUrls = <String>[];
        
        if (json['mediaUrls'] != null && json['mediaUrls'] is List && (json['mediaUrls'] as List).isNotEmpty) {
          final mediaUrls = json['mediaUrls'] as List;
          
          for (int i = 0; i < mediaUrls.length; i++) {
            final url = mediaUrls[i]?.toString();
            
            if (url != null && url.isNotEmpty) {
              // Simple heuristic: check file extension
              final lowerUrl = url.toLowerCase();
              if (lowerUrl.endsWith('.mp4') || lowerUrl.endsWith('.mov') || 
                  lowerUrl.endsWith('.avi') || lowerUrl.endsWith('.webm') ||
                  lowerUrl.contains('video')) {
                videoUrls.add(url);
              } else {
                imageUrls.add(url);
              }
            }
          }
          
          mappedJson['mediaImages'] = imageUrls;
          mappedJson['mediaVideos'] = videoUrls;
        }
        // Fallback to old field names if mediaUrls not present
        else {
          if (json['mediaPic'] != null || json['media_pic'] != null) {
            final pic = json['mediaPic'] ?? json['media_pic'];
            imageUrls.add(pic);
            mappedJson['mediaPic'] = pic;
          }
          if (json['mediaVideo'] != null || json['media_video'] != null) {
            final video = json['mediaVideo'] ?? json['media_video'];
            videoUrls.add(video);
            mappedJson['mediaVideo'] = video;
          }
          mappedJson['mediaImages'] = imageUrls;
          mappedJson['mediaVideos'] = videoUrls;
        }
        
        // Fetch real counts from interaction endpoints (if available)
        try {
          final counts = await _interactionsService.getPostCounts(tweetId);
          mappedJson['likes'] = counts['likes'] ?? 0;
          mappedJson['repost'] = counts['reposts'] ?? 0;
        } catch (e) {
          // Silently use defaults if endpoints not available
          mappedJson['likes'] = 0;
          mappedJson['repost'] = 0;
        }
        
        final tweet = TweetModel.fromJson(mappedJson);
        print('✅ Tweet fetched successfully');
        return tweet;
      } else {
        throw Exception('Failed to fetch tweet: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching tweet: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> addTweet(TweetModel tweet) async {
    try {
      print('📤 Creating tweet on backend...');
      print('   Body: ${tweet.body}');
      print('   Media Pic: ${tweet.mediaPic ?? "None"}');
      print('   Media Video: ${tweet.mediaVideo ?? "None"}');
      
      // Prepare form data
      final formData = FormData.fromMap({
        'userId': int.parse(tweet.userId),
        'content': tweet.body,
        'type': 'POST',
        'visibility': 'EVERY_ONE',
      });
      
      // Add media files if they exist (as local file paths)
      final mediaFiles = <MultipartFile>[];
      
      if (tweet.mediaPic != null && tweet.mediaPic!.isNotEmpty) {
        // Check if it's a local file path or URL
        if (!tweet.mediaPic!.startsWith('http')) {
          final file = File(tweet.mediaPic!);
          if (await file.exists()) {
            final multipartFile = await MultipartFile.fromFile(
              tweet.mediaPic!,
              filename: tweet.mediaPic!.split('/').last,
            );
            mediaFiles.add(multipartFile);
            print('   📷 Added image file to upload');
          }
        }
      }
      
      if (tweet.mediaVideo != null && tweet.mediaVideo!.isNotEmpty) {
        // Check if it's a local file path or URL
        if (!tweet.mediaVideo!.startsWith('http')) {
          final file = File(tweet.mediaVideo!);
          if (await file.exists()) {
            final multipartFile = await MultipartFile.fromFile(
              tweet.mediaVideo!,
              filename: tweet.mediaVideo!.split('/').last,
            );
            mediaFiles.add(multipartFile);
            print('   🎥 Added video file to upload');
          }
        }
      }
      
      // Add media files to form data if any
      if (mediaFiles.isNotEmpty) {
        formData.files.add(MapEntry('mediaFiles', mediaFiles.first));
        if (mediaFiles.length > 1) {
          for (var i = 1; i < mediaFiles.length; i++) {
            formData.files.add(MapEntry('mediaFiles', mediaFiles[i]));
          }
        }
      }
      
      // Send request
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
        print('   Response: ${response.data}');
      } else {
        throw Exception('Failed to create tweet: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating tweet: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateTweet(TweetModel tweet) async {
    try {
      print('📤 Updating tweet on backend: ${tweet.id}');
      
      final response = await _dio.put(
        '${ApiConfig.postsEndpoint}/${tweet.id}',
        data: tweet.toJson(),
      );
      
      if (response.statusCode == 200) {
        print('✅ Tweet updated successfully');
      } else {
        throw Exception('Failed to update tweet: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating tweet: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> deleteTweet(String id) async {
    try {
      print('📤 Deleting tweet on backend: $id');
      
      final response = await _dio.delete('${ApiConfig.postsEndpoint}/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Tweet deleted successfully');
      } else {
        throw Exception('Failed to delete tweet: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting tweet: $e');
      rethrow;
    }
  }
}
