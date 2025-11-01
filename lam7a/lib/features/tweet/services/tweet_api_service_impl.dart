import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Real implementation of Tweets API Service
/// Communicates with the backend server with authentication
class TweetsApiServiceImpl implements TweetsApiService {
  final ApiService _apiService;
  final PostInteractionsService _interactionsService;
  
  // Store interaction flags from backend responses
  final Map<String, Map<String, bool>> _interactionFlags = {};
  static const String _storageKey = 'tweet_interaction_flags';
  bool _isInitialized = false;

  TweetsApiServiceImpl({
    required ApiService apiService,
  })  : _apiService = apiService,
        _interactionsService = PostInteractionsService(apiService) {
    // Start loading flags in background (don't await in constructor)
    _loadStoredFlags();
  }
  
  /// Load interaction flags from SharedPreferences
  Future<void> _loadStoredFlags() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey);
      
      if (stored != null && stored.isNotEmpty) {
        final decoded = jsonDecode(stored) as Map<String, dynamic>;
        _interactionFlags.clear();
        
        decoded.forEach((key, value) {
          if (value is Map) {
            _interactionFlags[key] = Map<String, bool>.from(value);
          }
        });
        
        print('💾 Loaded ${_interactionFlags.length} stored interaction flags from disk');
      }
      
      _isInitialized = true;
    } catch (e) {
      print('⚠️ Error loading stored flags: $e');
      _isInitialized = true;
    }
  }
  
  /// Save interaction flags to SharedPreferences
  Future<void> _saveStoredFlags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_interactionFlags);
      await prefs.setString(_storageKey, encoded);
      print('💾 Saved ${_interactionFlags.length} interaction flags to disk');
    } catch (e) {
      print('⚠️ Error saving flags: $e');
    }
  }
  
  /// Get interaction flags for a tweet (isLikedByMe, isRepostedByMe)
  Future<Map<String, bool>?> getInteractionFlags(String tweetId) async {
    // Ensure flags are loaded before returning
    if (!_isInitialized) {
      await _loadStoredFlags();
    }
    return _interactionFlags[tweetId];
  }
  
  /// Update interaction flags after a toggle operation
  void updateInteractionFlag(String tweetId, String flagName, bool value) {
    if (_interactionFlags[tweetId] == null) {
      _interactionFlags[tweetId] = {};
    }
    _interactionFlags[tweetId]![flagName] = value;
    print('   🔄 Updated $flagName for tweet $tweetId: $value');
    
    // Persist to disk
    _saveStoredFlags();
  }
  
  @override
  Future<List<TweetModel>> getAllTweets() async {
    // Ensure flags are loaded before fetching tweets
    if (!_isInitialized) {
      await _loadStoredFlags();
    }
    
    try {
      final url = '${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}';
      print('📥 Fetching all tweets from backend...');
      print('   URL: $url');

      
      // Add query parameters to get latest tweets first with pagination
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        queryParameters: {
          'limit': 100, // Limit to 50 most recent tweets
          'page': 1,   // First page
          'sort': 'desc', // Sort by newest first (if backend supports it)
        },
      );
      

      
      final data = response['data'] as List;

        
        // Fetch each tweet individually using getTweetById to get complete data
        // This ensures we get media, counts, and all other fields
        final tweets = await Future.wait(data.map((json) async {
          final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();

          
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
        

      return tweets;
    } catch (e) {
      print('❌ Error fetching tweets: $e');
      rethrow;
    }
  }
  
  @override
  Future<TweetModel> getTweetById(String id) async {
    try {

      
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$id',
      );
      
      final json = response['data'];
        // Map backend fields to frontend model
        final tweetId = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
        

        
        // Parse user data from nested User/Profile structure
        String? username;
        String? authorName;
        String? authorProfileImage;
        
        // Check if User object exists (nested structure from backend)
        if (json['User'] != null && json['User'] is Map) {
          final user = json['User'] as Map;

          username = user['username']?.toString();
          
          // Check for nested Profile
          if (user['Profile'] != null && user['Profile'] is Map) {
            final profile = user['Profile'] as Map;

            authorName = profile['name']?.toString();
            authorProfileImage = profile['profile_image_url']?.toString();
          }
        } else {
          // Flat structure (fallback)

          username = json['username']?.toString();
          authorName = json['authorName']?.toString();
          authorProfileImage = json['authorProfileImage']?.toString();
        }
        

        
        final mappedJson = <String, dynamic>{
          'id': tweetId,
          'userId': (json['user_id'] ?? json['userId'])?.toString() ?? '0',
          'body': (json['content'] ?? json['body'] ?? '').toString(),
          'date': (json['createdAt'] ?? json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString(),
          // User information from backend
          'username': username,
          'authorName': authorName,
          'authorProfileImage': authorProfileImage,
          // User interaction flags from backend
          'isLikedByMe': json['isLikedByMe'] ?? false,
          'isRepostedByMe': json['isRepostedByMe'] ?? false,
        };
        
        
        // Parse media from backend - supporting multiple formats
        final imageUrls = <String>[];
        final videoUrls = <String>[];
        
        // Format 1: media array with type info (from getPostById)
        if (json['media'] != null && json['media'] is List && (json['media'] as List).isNotEmpty) {
          final mediaArray = json['media'] as List;

          
          for (final mediaItem in mediaArray) {
            final url = mediaItem['media_url']?.toString();
            final type = mediaItem['type']?.toString();
            
            if (url != null && url.isNotEmpty) {
             
              if (type == 'VIDEO') {
                videoUrls.add(url);
              } else {
                imageUrls.add(url);
              }
            }
          }
          
          mappedJson['mediaImages'] = imageUrls;
          mappedJson['mediaVideos'] = videoUrls;
        
        }
        // Format 2: mediaUrls array (fallback)
        else if (json['mediaUrls'] != null && json['mediaUrls'] is List && (json['mediaUrls'] as List).isNotEmpty) {
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
        // Format 3: Old field names (legacy)
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
      
      // Store interaction flags separately (not in TweetModel)
      // These will be used by TweetViewModel to initialize TweetState
      
      // Check if we have existing stored flags for this tweet
      final existingFlags = _interactionFlags[tweetId];
      
      // Check if backend provided the flags
      bool isLikedByMe;
      bool isRepostedByMe;
      
      // Check if the keys exist in the response (not just if they're not null)
      final hasLikedFlag = json.containsKey('isLikedByMe');
      final hasRepostedFlag = json.containsKey('isRepostedByMe');
      
      if (hasLikedFlag && hasRepostedFlag) {
        // Backend provided flags (from feed endpoints) - use them
        isLikedByMe = json['isLikedByMe'] ?? false;
        isRepostedByMe = json['isRepostedByMe'] ?? false;
 
      } else if (existingFlags != null) {
        // Backend didn't provide flags, but we have stored flags - preserve them
        isLikedByMe = existingFlags['isLikedByMe'] ?? false;
        isRepostedByMe = existingFlags['isRepostedByMe'] ?? false;
     
      } else {
        // No backend flags and no stored flags - default to false
        isLikedByMe = false;
        isRepostedByMe = false;
        print('   ⚠️ No interaction flags available, defaulting to false');
      }
      
      _interactionFlags[tweetId] = {
        'isLikedByMe': isLikedByMe,
        'isRepostedByMe': isRepostedByMe,
      };
      
    
      return tweet;
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
      
      // Send request using ApiService post method
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      print('✅ Tweet created successfully on backend!');
      print('   Response: $response');
    } catch (e) {
      print('❌ Error creating tweet: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> updateTweet(TweetModel tweet) async {
    try {
      print('📤 Updating tweet on backend: ${tweet.id}');
      
      await _apiService.put<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/${tweet.id}',
        data: tweet.toJson(),
      );
      
      print('✅ Tweet updated successfully');
    } catch (e) {
      print('❌ Error updating tweet: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> deleteTweet(String id) async {
    try {
      print('📤 Deleting tweet on backend: $id');
      
      await _apiService.delete<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$id',
      );
      
      print('✅ Tweet deleted successfully');
    } catch (e) {
      print('❌ Error deleting tweet: $e');
      rethrow;
    }
  }
}
