import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';

/// Real implementation of Tweets API Service
/// Communicates with the backend server with authentication
class TweetsApiServiceImpl implements TweetsApiService {
  final ApiService _apiService;
  late final PostInteractionsService _interactionsService;
  
  TweetsApiServiceImpl({required ApiService apiService}) 
      : _apiService = apiService {
    _interactionsService = PostInteractionsService(_apiService);
  }
  
  @override
  Future<List<TweetModel>> getAllTweets() async {
    try {
      final url = '${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}';
      print('📥 Fetching all tweets from backend...');
      print('   URL: $url');
      
      // Add query parameters to get latest tweets first with pagination
      final response = await _apiService.dio.get(
        ApiConfig.postsEndpoint,
        queryParameters: {
          'limit': 50, // Limit to 50 most recent tweets
          'page': 1,   // First page
          'sort': 'desc', // Sort by newest first (if backend supports it)
        },
      );
      
      print('   Response status: ${response.statusCode}');
      print('   Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        print('   Raw tweet data count: ${data.length}');
        
        // Fetch each tweet individually using getTweetById to get complete data
        // This ensures we get media, counts, and all other fields
        final tweets = await Future.wait(data.map((json) async {
          final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
          print('   📍 Fetching full data for tweet: $tweetId');
          
          try {
            // Use getTweetById to get complete tweet data with media and counts
            return await getTweetById(tweetId);
          } catch (e) {
            print('   ⚠️ Error fetching tweet $tweetId: $e');
            // Fallback to basic parsing if getTweetById fails
            return TweetModel(
              id: tweetId,
              userId: (json['user_id'] ?? json['userId'])?.toString() ?? '0',
              body: (json['content'] ?? json['body'] ?? '').toString(),
              date: json['createdAt'] != null 
                  ? DateTime.parse(json['createdAt']) 
                  : DateTime.now(),
              likes: 0,
              repost: 0,
              comments: 0,
              views: 0,
              qoutes: 0,
              bookmarks: 0,
              mediaImages: [],
              mediaVideos: [],
            );
          }
        }).toList());
        
        print('✅ Fetched ${tweets.length} tweets with complete data');
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
      
      final response = await _apiService.dio.get('${ApiConfig.postsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final json = response.data['data'];
        // Map backend fields to frontend model
        final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
        
        final mappedJson = <String, dynamic>{
          'id': tweetId,
          'userId': (json['user_id'] ?? json['userId'])?.toString() ?? '0',
          'body': (json['content'] ?? json['body'] ?? '').toString(),
          'date': (json['createdAt'] ?? json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString(),
        };
        
        // Parse media from backend - supporting multiple formats
        final imageUrls = <String>[];
        final videoUrls = <String>[];
        
        // Format 1: media array with type info (from getPostById)
        if (json['media'] != null && json['media'] is List && (json['media'] as List).isNotEmpty) {
          final mediaArray = json['media'] as List;
          print('   📷 Media array found: ${mediaArray.length} items');
          
          for (final mediaItem in mediaArray) {
            final url = mediaItem['media_url']?.toString();
            final type = mediaItem['type']?.toString();
            
            if (url != null && url.isNotEmpty) {
              print('      - URL: $url (type: $type)');
              if (type == 'VIDEO') {
                videoUrls.add(url);
              } else {
                imageUrls.add(url);
              }
            }
          }
          
          mappedJson['mediaImages'] = imageUrls;
          mappedJson['mediaVideos'] = videoUrls;
          print('   📊 Parsed: ${imageUrls.length} images, ${videoUrls.length} videos');
        }
        // Format 2: mediaUrls array (fallback)
        else if (json['mediaUrls'] != null && json['mediaUrls'] is List && (json['mediaUrls'] as List).isNotEmpty) {
          final mediaUrls = json['mediaUrls'] as List;
          print('   📷 MediaUrls found: ${mediaUrls.length} items');
          
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
        // Format 3: Old field names (legacy)
        else {
          print('   ℹ️ No media array, checking old fields');
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
      final response = await _apiService.dio.post(
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
      
      final response = await _apiService.dio.put(
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
      
      final response = await _apiService.dio.delete('${ApiConfig.postsEndpoint}/$id');
      
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
