import 'dart:io';
import 'dart:convert';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';

void printFullJson(dynamic json) {
  final prettyString = const JsonEncoder.withIndent('  ').convert(json);
  debugPrint(prettyString, wrapWidth: 1024);
}

/// Real implementation of Tweets API Service
/// Communicates with the backend server with authentication
class TweetsApiServiceImpl implements TweetsApiService {
  final ApiService _apiService;
  final PostInteractionsService _interactionsService;

  // Store interaction flags from backend responses
  final Map<String, Map<String, bool>> _interactionFlags = {};
  // Store per-tweet local views override (e.g., after client-side increments)
  final Map<String, int> _localViews = {};
  static const String _storageKey = 'tweet_interaction_flags';
  static const String _viewsStorageKey = 'tweet_views_overrides';
  bool _isInitialized = false;

  TweetsApiServiceImpl({required ApiService apiService})
    : _apiService = apiService,
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

        print(
          '💾 Loaded ${_interactionFlags.length} stored interaction flags from disk',
        );
      }

      // Load stored views overrides
      final storedViews = prefs.getString(_viewsStorageKey);
      if (storedViews != null && storedViews.isNotEmpty) {
        final decodedViews = jsonDecode(storedViews) as Map<String, dynamic>;
        _localViews.clear();
        decodedViews.forEach((key, value) {
          final intVal = int.tryParse(value.toString());
          if (intVal != null) {
            _localViews[key] = intVal;
          }
        });

        print(
          '💾 Loaded ${_localViews.length} stored view overrides from disk',
        );
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
      final encodedFlags = jsonEncode(_interactionFlags);
      await prefs.setString(_storageKey, encodedFlags);
      final encodedViews = jsonEncode(_localViews);
      await prefs.setString(_viewsStorageKey, encodedViews);
      print(
        '💾 Saved ${_interactionFlags.length} interaction flags and ${_localViews.length} view overrides to disk',
      );
    } catch (e) {
      print('⚠️ Error saving flags: $e');
    }
  }

  /// Get interaction flags for a tweet (isLikedByMe, isRepostedByMe)
  @override
  Future<Map<String, bool>?> getInteractionFlags(String tweetId) async {
    // Ensure flags are loaded before returning
    if (!_isInitialized) {
      await _loadStoredFlags();
    }
    return _interactionFlags[tweetId];
  }

  /// Update interaction flags after a toggle operation
  @override
  void updateInteractionFlag(String tweetId, String flagName, bool value) {
    if (_interactionFlags[tweetId] == null) {
      _interactionFlags[tweetId] = {};
    }
    _interactionFlags[tweetId]![flagName] = value;
    print('   🔄 Updated $flagName for tweet $tweetId: $value');

    // Persist to disk
    _saveStoredFlags();
  }

  /// Get locally stored views override for a tweet, if any
  @override
  int? getLocalViews(String tweetId) {
    return _localViews[tweetId];
  }

  /// Set locally stored views override for a tweet
  @override
  void setLocalViews(String tweetId, int views) {
    _localViews[tweetId] = views;
    _saveStoredFlags();
  }

  @override
  Future<List<TweetModel>> getAllTweets(int limit, int page) async {
    // Ensure flags are loaded before fetching tweets
    if (!_isInitialized) {
      await _loadStoredFlags();
    }

    try {
      final url =
          '${ApiConfig.currentBaseUrl}${ApiConfig.postsEndpoint}/timeline/for-you';
      print('📥 Fetching For You feed from backend...');
      print('   URL: $url');

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/timeline/for-you',
        queryParameters: {'limit': limit, 'page': page},
      );

      // Backend returns: { status, message, data: { posts: [...] } }
      final dataWrapper = response['data'];
      final postsJson = (dataWrapper is Map && dataWrapper['posts'] is List)
          ? (dataWrapper['posts'] as List)
          : <dynamic>[];

      List<TweetModel> tweets = [];

      for (final raw in postsJson) {
        if (raw is! Map) continue;
        final json = raw as Map;

        final tweetId =
            (json['postId'] ??
                    json['id'] ??
                    DateTime.now().millisecondsSinceEpoch)
                .toString();

        // Basic user info
        final username = json['username']?.toString();
        final authorName = json['name']?.toString();
        final authorProfileImage = json['avatar']?.toString();

        int parseInt(dynamic v) =>
            v == null ? 0 : (v is int ? v : int.tryParse(v.toString()) ?? 0);

        // Counts from feed
        final likes = parseInt(json['likesCount']);
        final reposts = parseInt(json['retweetsCount']);
        final comments = parseInt(json['commentsCount']);

        // Interaction and repost metadata flags
        final isLikedByMe = json['isLikedByMe'] ?? false;
        final isRepostedByMe = json['isRepostedByMe'] ?? false;
        final isRepost = json['isRepost'] ?? false;
        final isQuote = json['isQuote'] ?? false;

        // Original post data for reposts/quotes (to show nested parent tweet)
        Map<String, dynamic>? originalTweetJson;
        final original = json['originalPostData'];
        if (original is Map) {
          final o = original;

          final originalId =
              (o['postId'] ?? o['id'] ?? DateTime.now().millisecondsSinceEpoch)
                  .toString();

          final originalUserId = (o['userId'] ?? o['user_id'] ?? '0')
              .toString();

          final rawDate = o['date'] ?? o['createdAt'] ?? o['created_at'];
          String originalDateString;
          if (rawDate is String) {
            originalDateString = rawDate;
          } else if (rawDate is DateTime) {
            originalDateString = rawDate.toIso8601String();
          } else {
            originalDateString = DateTime.now().toIso8601String();
          }

          final originalLikes = parseInt(o['likesCount']);
          final originalReposts = parseInt(o['retweetsCount']);
          final originalComments = parseInt(o['commentsCount']);

          final originalImageUrls = <String>[];
          final originalVideoUrls = <String>[];
          if (o['media'] is List) {
            for (final m in (o['media'] as List)) {
              if (m is! Map) continue;
              final url = m['url']?.toString();
              final type = m['type']?.toString();
              if (url == null || url.isEmpty) continue;
              if (type == 'VIDEO') {
                originalVideoUrls.add(url);
              } else {
                originalImageUrls.add(url);
              }
            }
          }

          originalTweetJson = <String, dynamic>{
            'id': originalId,
            'userId': originalUserId,
            'body': (o['text'] ?? o['content'] ?? '').toString(),
            'date': originalDateString,
            'username': o['username']?.toString(),
            'authorName': o['name']?.toString(),
            'authorProfileImage': o['avatar']?.toString(),
            'likes': originalLikes,
            'repost': originalReposts,
            'comments': originalComments,
            'views': 0,
            'qoutes': 0,
            'bookmarks': 0,
            'mediaImages': originalImageUrls,
            'mediaVideos': originalVideoUrls,
            'isRepost': false,
            'isQuote': false,
          };
        }

        // Media
        final imageUrls = <String>[];
        final videoUrls = <String>[];
        if (json['media'] is List) {
          for (final m in (json['media'] as List)) {
            if (m is! Map) continue;
            final url = m['url']?.toString();
            final type = m['type']?.toString();
            if (url == null || url.isEmpty) continue;
            if (type == 'VIDEO') {
              videoUrls.add(url);
            } else {
              imageUrls.add(url);
            }
          }
        }

        final mappedJson = <String, dynamic>{
          'id': tweetId,
          'userId': (json['userId'] ?? json['user_id'] ?? '0').toString(),
          'body': (json['text'] ?? json['content'] ?? '').toString(),
          'date':
              (json['date'] ??
                      json['createdAt'] ??
                      DateTime.now().toIso8601String())
                  .toString(),
          'username': username,
          'authorName': authorName,
          'authorProfileImage': authorProfileImage,
          'likes': likes,
          'repost': reposts,
          'comments': comments,
          'views': 0,
          'qoutes': 0,
          'bookmarks': 0,
          'mediaImages': imageUrls,
          'mediaVideos': videoUrls,
          'isRepost': isRepost,
          'isQuote': isQuote,
        };

        if (originalTweetJson != null) {
          mappedJson['originalTweet'] = originalTweetJson;
        }

        final tweet = TweetModel.fromJson(mappedJson);

        // Store interaction flags and repost metadata for this tweet
        final existingFlags = _interactionFlags[tweetId] ?? <String, bool>{};
        _interactionFlags[tweetId] = {
          ...existingFlags,
          'isLikedByMe': isLikedByMe,
          'isRepostedByMe': isRepostedByMe,
          'isRepost': isRepost,
          'isQuote': isQuote,
        };

        tweets.add(tweet);
      }

      // Also fetch the authenticated user's own posts from /posts/profile/me
      // and merge them into the home feed so they persist after refresh.
      try {
        final profileResponse = await _apiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/profile/me',
          queryParameters: {'limit': 50, 'page': 1},
        );

        final profileData = profileResponse['data'];
        List<dynamic> profilePostsJson = [];

        if (profileData is List) {
          profilePostsJson = profileData;
        } else if (profileData is Map && profileData['posts'] is List) {
          profilePostsJson = (profileData['posts'] as List);
        }

        // Track IDs already present from the For You feed
        final existingIds = tweets.map((t) => t.id).toSet();
        final idsToFetch = <String>[];
        final quoteParentMap = <String, String>{};

        for (final raw in profilePostsJson) {
          if (raw is! Map) continue;
          final map = raw as Map;
          final postId = (map['id'] ?? map['postId'])?.toString();
          if (postId == null) continue;
          if (existingIds.contains(postId)) continue;

          existingIds.add(postId);
          idsToFetch.add(postId);

          // Detect quotes and remember their parent IDs so we can attach
          final type = map['type']?.toString();
          final parentRaw = map['parent_id'] ?? map['parentId'];
          final parentId = parentRaw != null ? parentRaw.toString() : null;
          if (type == 'QUOTE' && parentId != null && parentId.isNotEmpty) {
            quoteParentMap[postId] = parentId;
          }
        }

        if (idsToFetch.isNotEmpty) {
          final profileTweets = await Future.wait(
            idsToFetch.map((id) => getTweetById(id)),
          );

          final enhancedProfileTweets = <TweetModel>[];

          for (final tweet in profileTweets) {
            final parentId = quoteParentMap[tweet.id];
            if (parentId != null) {
              try {
                final parentTweet = await getTweetById(parentId);
                enhancedProfileTweets.add(
                  tweet.copyWith(isQuote: true, originalTweet: parentTweet),
                );
              } catch (e) {
                print(
                  '⚠️ Error fetching parent tweet $parentId for quote ${tweet.id}: $e',
                );
                enhancedProfileTweets.add(tweet);
              }
            } else {
              enhancedProfileTweets.add(tweet);
            }
          }

          tweets.addAll(enhancedProfileTweets);
        }
      } catch (e) {
        // If profile/me is unavailable or user is unauthenticated, just skip
        print('⚠️ Error fetching profile posts for current user: $e');
      }

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
      final data = response['data'];
      final dynamic json = (data is List && data.isNotEmpty)
          ? data.first
          : data;
      // Map backend fields to frontend model (supports both transformed and legacy shapes)
      final tweetId =
          (json['postId'] ??
                  json['id'] ??
                  DateTime.now().millisecondsSinceEpoch)
              .toString();

      // Parse user data from either transformed flat structure or nested User/Profile
      String? username;
      String? authorName;
      String? authorProfileImage;

      // Prefer transformed flat structure when available
      if (json['username'] != null ||
          json['name'] != null ||
          json['avatar'] != null) {
        username = json['username']?.toString();
        authorName = (json['authorName'] ?? json['name'])?.toString();
        authorProfileImage = (json['authorProfileImage'] ?? json['avatar'])
            ?.toString();
      } else if (json['User'] != null && json['User'] is Map) {
        // Nested User/Profile structure (legacy)
        final user = json['User'] as Map;

        username = user['username']?.toString();

        if (user['Profile'] != null && user['Profile'] is Map) {
          final profile = user['Profile'] as Map;

          authorName = profile['name']?.toString();
          authorProfileImage = profile['profile_image_url']?.toString();
        }
      } else {
        // Flat legacy structure
        username = json['username']?.toString();
        authorName = (json['authorName'] ?? json['name'])?.toString();
        authorProfileImage = (json['authorProfileImage'] ?? json['avatar'])
            ?.toString();
      }

      // Fallback avatar field used by some endpoints (e.g. transformed feeds)
      authorProfileImage ??= json['avatar']?.toString();

      int parseInt(dynamic v) =>
          v == null ? 0 : int.tryParse(v.toString()) ?? 0;

      // Engagement counts coming directly from backend
      int likes = 0;
      int reposts = 0;
      int comments = 0;
      int views = 0;
      int quotes = 0;
      int bookmarks = 0;

      // New transformed post counts (For You / getPostById)
      likes = parseInt(json['likesCount'] ?? likes);
      reposts = parseInt(json['retweetsCount'] ?? reposts);
      comments = parseInt(json['commentsCount'] ?? comments);

      // Legacy _count structure (Prisma style)
      final countData = json['_count'];
      if (countData is Map) {
        likes = parseInt(countData['likes'] ?? likes);
        reposts = parseInt(countData['repostedBy'] ?? reposts);
        comments = parseInt(countData['Replies'] ?? comments);
      }

      // Direct numeric fields (fallback)
      likes = parseInt(json['likes'] ?? likes);
      reposts = parseInt(json['repost'] ?? json['reposts'] ?? reposts);
      comments = parseInt(json['comments'] ?? comments);
      views = parseInt(json['views'] ?? json['viewsCount'] ?? views);
      quotes = parseInt(json['qoutes'] ?? json['quotes'] ?? quotes);
      bookmarks = parseInt(json['bookmarks'] ?? bookmarks);

      final mappedJson = <String, dynamic>{
        'id': tweetId,
        'userId': (json['userId'] ?? json['user_id'])?.toString() ?? '0',
        'body': (json['text'] ?? json['content'] ?? json['body'] ?? '')
            .toString(),
        'date':
            (json['date'] ??
                    json['createdAt'] ??
                    json['created_at'] ??
                    DateTime.now().toIso8601String())
                .toString(),
        // User information from backend
        'username': username,
        'authorName': authorName ?? username,
        'authorProfileImage': authorProfileImage,
        // Engagement counts from backend
        'likes': likes,
        'repost': reposts,
        'comments': comments,
        'views': views,
        'qoutes': quotes,
        'bookmarks': bookmarks,
        // User interaction flags from backend
        'isLikedByMe': json['isLikedByMe'] ?? false,
        'isRepostedByMe': json['isRepostedByMe'] ?? false,
      };

      // Parse media from backend - supporting multiple formats
      final imageUrls = <String>[];
      final videoUrls = <String>[];

      // Format 1: media array with type info (from transformed or legacy getPostById)
      if (json['media'] != null &&
          json['media'] is List &&
          (json['media'] as List).isNotEmpty) {
        final mediaArray = json['media'] as List;

        for (final mediaItem in mediaArray) {
          if (mediaItem is! Map) continue;
          final url = (mediaItem['url'] ?? mediaItem['media_url'])?.toString();
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
      else if (json['mediaUrls'] != null &&
          json['mediaUrls'] is List &&
          (json['mediaUrls'] as List).isNotEmpty) {
        final mediaUrls = json['mediaUrls'] as List;

        for (int i = 0; i < mediaUrls.length; i++) {
          final url = mediaUrls[i]?.toString();

          if (url != null && url.isNotEmpty) {
            // Simple heuristic: check file extension
            final lowerUrl = url.toLowerCase();
            if (lowerUrl.endsWith('.mp4') ||
                lowerUrl.endsWith('.mov') ||
                lowerUrl.endsWith('.avi') ||
                lowerUrl.endsWith('.webm') ||
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

      final updatedFlags = <String, bool>{
        ...?existingFlags,
        'isLikedByMe': isLikedByMe,
        'isRepostedByMe': isRepostedByMe,
      };

      _interactionFlags[tweetId] = updatedFlags;

      return tweet;
    } catch (e) {
      print('❌ Error fetching tweet: $e');
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

  /// Get replies for a specific post
  /// Uses backend endpoint: GET /posts/{postId}/replies
  Future<List<TweetModel>> getRepliesForPost(String postId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/replies',
        queryParameters: {'page': 1, 'limit': 50},
      );

      final data = response['data'];
      if (data is! List) {
        return [];
      }

      List<TweetModel> replies = [];

      for (final raw in data) {
        if (raw is! Map) continue;
        final json = raw as Map<String, dynamic>;

        // New hierarchical shape from backend (TransformedPost with
        // originalPostData for replies/quotes/reposts). When present, use the
        // dedicated mapper to preserve parent tweet information.
        try {
          if (json.containsKey('postId') && json.containsKey('date')) {
            replies.add(TweetModel.fromJsonPosts(json));
            continue;
          }
        } catch (e) {
          print('⚠️ Failed to parse reply via fromJsonPosts, falling back: $e');
        }

        // Legacy/fallback mapping for older backend reply shapes.
        final replyId =
            (json['postId'] ??
                    json['id'] ??
                    DateTime.now().millisecondsSinceEpoch)
                .toString();

        // Basic user info (same style as feed)
        String? username;
        String? authorName;
        String? authorProfileImage;

        if (json['User'] != null && json['User'] is Map) {
          final user = json['User'] as Map;
          username = user['username']?.toString();

          if (user['Profile'] != null && user['Profile'] is Map) {
            final profile = user['Profile'] as Map;
            authorName = profile['name']?.toString();
            authorProfileImage = profile['profile_image_url']?.toString();
          }
        } else {
          username = json['username']?.toString();
          authorName = json['authorName']?.toString();
          authorProfileImage = json['authorProfileImage']?.toString();
        }

        authorProfileImage ??= json['avatar']?.toString();

        int parseInt(dynamic v) =>
            v == null ? 0 : (v is int ? v : int.tryParse(v.toString()) ?? 0);

        final likes = parseInt(json['likes'] ?? json['likesCount']);
        final reposts = parseInt(
          json['repost'] ?? json['reposts'] ?? json['retweetsCount'],
        );
        final comments = parseInt(json['comments'] ?? json['commentsCount']);

        final imageUrls = <String>[];
        final videoUrls = <String>[];

        if (json['media'] is List) {
          for (final m in (json['media'] as List)) {
            if (m is! Map) continue;
            final url = m['url']?.toString() ?? m['media_url']?.toString();
            final type = m['type']?.toString();
            if (url == null || url.isEmpty) continue;
            if (type == 'VIDEO') {
              videoUrls.add(url);
            } else {
              imageUrls.add(url);
            }
          }
        }

        final mappedJson = <String, dynamic>{
          'id': replyId,
          'userId': (json['userId'] ?? json['user_id'] ?? '0').toString(),
          'body': (json['text'] ?? json['content'] ?? json['body'] ?? '')
              .toString(),
          'date':
              (json['createdAt'] ??
                      json['created_at'] ??
                      json['date'] ??
                      DateTime.now().toIso8601String())
                  .toString(),
          'username': username,
          'authorName': authorName,
          'authorProfileImage': authorProfileImage,
          'likes': likes,
          'repost': reposts,
          'comments': comments,
          'views': parseInt(json['views'] ?? json['viewsCount']),
          'qoutes': parseInt(json['qoutes'] ?? json['quotes']),
          'bookmarks': parseInt(json['bookmarks']),
          'mediaImages': imageUrls,
          'mediaVideos': videoUrls,
        };

        final reply = TweetModel.fromJson(mappedJson);
        replies.add(reply);
      }

      return replies;
    } catch (e) {
      print('❌ Error fetching replies for post $postId: $e');
      return [];
    }
  }

  List<String> parseMedia(dynamic media) {
    if (media == null) return [];

    if (media is List) {
      return media
          .map<String>((item) {
            if (item is String) return item;

            if (item is Map) return item['url'] ?? "";

            return "";
          })
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  @override
  Future<List<TweetModel>> getTweets(
    int limit,
    int page,
    String tweetsType,
  ) async {
    String endpoint = ServerConstant.tweetsForYou;
    Map<String, dynamic> response = await _apiService.get(
      endpoint: "/posts/timeline/" + tweetsType,
      queryParameters: {"limit": limit, "page": page},
    );

    List<dynamic> postsJson = response['data']['posts'];

    List<TweetModel> tweets = postsJson.map((post) {
      bool isRepost = post['isRepost'] ?? false;
      bool isQuote = post['isQuote'] ?? false;

      Map<String, dynamic>? originalJson;
      final rawOriginal = post['originalPostData'];
      if ((isRepost || isQuote) && rawOriginal is Map<String, dynamic>) {
        originalJson = rawOriginal;
      }

      return TweetModel(
        id: post['postId'].toString(),
        body: post['text'] ?? '',

        mediaImages: parseMedia(post['media']),
        mediaVideos: const [],

        date: DateTime.parse(post['date']),
        likes: post['likesCount'] ?? 0,
        qoutes: post['commentsCount'] ?? 0,
        repost: post['retweetsCount'] ?? 0,
        comments: post['commentsCount'] ?? 0,
        userId: post['userId'].toString(),

        username: post['username'],
        authorName: post['name'],
        authorProfileImage: post['avatar'],

        isRepost: isRepost,
        isQuote: isQuote,

        originalTweet: originalJson != null
            ? TweetModel(
                id: originalJson['postId'].toString(),
                body: originalJson['text'] ?? '',

                mediaImages: parseMedia(originalJson['media']),
                mediaVideos: const [],

                date: DateTime.parse(originalJson['date']),
                likes: originalJson['likesCount'] ?? 0,
                qoutes: originalJson['commentsCount'] ?? 0,
                repost: originalJson['retweetsCount'] ?? 0,
                comments: originalJson['commentsCount'] ?? 0,
                userId: originalJson['userId'].toString(),

                username: originalJson['username'],
                authorName: originalJson['name'],
                authorProfileImage: originalJson['avatar'],

                isRepost: false,
                isQuote: false,
              )
            : null,
      );
    }).toList();

    return tweets;
  }

  @override
  Future<String> getTweetSummery(String tweetId) async {
    Map<String, dynamic> response = await _apiService.get(
      endpoint: "/posts/summary/$tweetId",
    );

    String summary = response['data'] ?? "";

    return summary;
  }
  // @override
  // Future<Future<List<TweetModel>>> getFollowingTweets(int limit, int page) {

  // }

  // for the profile feature

  // ===================== PROFILE POSTS ============================
  @override
  Future<List<TweetModel>> getTweetsByUser(String userId) async {
    final response = await _apiService.get(endpoint: "/posts/profile/$userId");
    final data = response["data"];

    if (data is! List) return [];

    return data.map<TweetModel>((json) {
      final isRepost = json['isRepost'] == true;
      final isQuote = json['isQuote'] == true;
      final original = json['originalPostData'];

      // ---------------------------------------------------------
      // CASE 1: REPOST  → RETURN ONLY ORIGINAL TWEET
      // ---------------------------------------------------------
      if (isRepost && original is Map<String, dynamic>) {
        return TweetModel(
          id: original['postId'].toString(),
          userId: original['userId'].toString(),
          username: original['username'],
          authorName: original['name'],
          authorProfileImage: original['avatar'],
          body: original['text'] ?? '',
          date: DateTime.parse(original['date']),
          likes: original['likesCount'] ?? 0,
          repost: original['retweetsCount'] ?? 0,
          comments: original['commentsCount'] ?? 0,
          isRepost: true,
          isQuote: false,
          mediaImages: _extractImages(original),
          mediaVideos: _extractVideos(original),
        );
      }

      // ---------------------------------------------------------
      // CASE 2: QUOTE  → RETURN ONLY QUOTE CONTENT
      // ---------------------------------------------------------
      if (isQuote && original is Map<String, dynamic>) {
        final parent = TweetModel(
          id: original['postId'].toString(),
          userId: original['userId'].toString(),
          username: original['username'],
          authorName: original['name'],
          authorProfileImage: original['avatar'],
          body: original['text'] ?? '',
          date: DateTime.parse(original['date']),
          likes: original['likesCount'] ?? 0,
          repost: original['retweetsCount'] ?? 0,
          comments: original['commentsCount'] ?? 0,
          mediaImages: _extractImages(original),
          mediaVideos: _extractVideos(original),
        );

        return TweetModel(
          id: json['postId'].toString(),
          userId: json['userId'].toString(),
          username: json['username'],
          authorName: json['name'],
          authorProfileImage: json['avatar'],
          body: json['text'] ?? "",
          date: DateTime.parse(json['date']),
          likes: json['likesCount'] ?? 0,
          repost: json['retweetsCount'] ?? 0,
          comments: json['commentsCount'] ?? 0,
          isRepost: false,
          isQuote: true,
          mediaImages: _extractImages(json),
          mediaVideos: _extractVideos(json),
          originalTweet: parent,
        );
      }

      // ---------------------------------------------------------
      // CASE 3: NORMAL POST
      // ---------------------------------------------------------
      return TweetModel(
        id: json['postId'].toString(),
        userId: json['userId'].toString(),
        username: json['username'],
        authorName: json['name'],
        authorProfileImage: json['avatar'],
        body: json['text'] ?? '',
        date: DateTime.parse(json['date']),
        likes: json['likesCount'] ?? 0,
        repost: json['retweetsCount'] ?? 0,
        comments: json['commentsCount'] ?? 0,
        isRepost: false,
        isQuote: false,
        mediaImages: _extractImages(json),
        mediaVideos: _extractVideos(json),
      );
    }).toList();
  }

  // ===================== PROFILE REPLIES ============================
  @override
  Future<List<TweetModel>> getRepliesByUser(String userId) async {
    final response = await _apiService.get(
      endpoint: "/posts/profile/$userId/replies",
    );

    final data = response["data"];
    if (data is! List) return [];

    return data.map<TweetModel>((json) {
      final original = json['originalPostData'];

      // Parent tweet (what reply is replying to)
      TweetModel? parentTweet;
      if (original is Map<String, dynamic>) {
        parentTweet = TweetModel(
          id: original['postId'].toString(),
          userId: original['userId'].toString(),
          username: original['username'],
          authorName: original['name'],
          authorProfileImage: original['avatar'],
          body: original['text'] ?? '',
          date: DateTime.parse(original['date']),
          likes: original['likesCount'] ?? 0,
          repost: original['retweetsCount'] ?? 0,
          comments: original['commentsCount'] ?? 0,
          mediaImages: _extractImages(original),
          mediaVideos: _extractVideos(original),
        );
      }

      // The reply itself
      return TweetModel(
        id: json['postId'].toString(),
        userId: json['userId'].toString(),
        username: json['username'],
        authorName: json['name'],
        authorProfileImage: json['avatar'],
        body: json['text'] ?? '',
        date: DateTime.parse(json['date']),
        likes: json['likesCount'] ?? 0,
        repost: json['retweetsCount'] ?? 0,
        comments: json['commentsCount'] ?? 0,
        isRepost: false,
        isQuote: false,
        mediaImages: _extractImages(json),
        mediaVideos: _extractVideos(json),
        originalTweet: parentTweet,
      );
    }).toList();
  }

  // ===================== PROFILE LIKES ============================
  @override
  Future<List<TweetModel>> getUserLikedPosts(String userId) async {
    final response = await _apiService.get(endpoint: "/posts/liked/$userId");

    final data = response["data"];
    if (data is! List) return [];

    return data.map<TweetModel>((json) {
      return TweetModel(
        id: json['postId'].toString(),
        userId: json['userId'].toString(),
        username: json['username'],
        authorName: json['name'],
        authorProfileImage: json['avatar'],
        body: json['text'] ?? '',
        date: DateTime.parse(json['date']),
        likes: json['likesCount'] ?? 0,
        repost: json['retweetsCount'] ?? 0,
        comments: json['commentsCount'] ?? 0,
        isRepost: json['isRepost'] ?? false,
        isQuote: json['isQuote'] ?? false,
        mediaImages: _extractImages(json),
        mediaVideos: _extractVideos(json),
      );
    }).toList();
  }

  // Helper: extract non-video image urls from a backend post JSON
  List<String> _extractImages(Map<String, dynamic> json) {
    final media = json['media'];
    if (media == null || media is! List) return <String>[];

    final images = <String>[];
    for (final item in media) {
      if (item == null) continue;
      if (item is String) {
        images.add(item);
        continue;
      }
      if (item is Map) {
        final type = (item['type'] ?? item['mediaType'])
            ?.toString()
            .toUpperCase();
        final url = (item['url'] ?? item['media_url'] ?? item['mediaUrl'])
            ?.toString();
        if (url == null || url.isEmpty) continue;
        // treat non-video as image
        if (type != 'VIDEO') images.add(url);
      }
    }
    return images;
  }

  // Helper: extract video urls from a backend post JSON
  List<String> _extractVideos(Map<String, dynamic> json) {
    final media = json['media'];
    if (media == null || media is! List) return <String>[];

    final videos = <String>[];
    for (final item in media) {
      if (item == null) continue;
      if (item is String) {
        final lower = item.toLowerCase();
        if (lower.endsWith('.mp4') || lower.contains('video')) videos.add(item);
        continue;
      }
      if (item is Map) {
        final type = (item['type'] ?? item['mediaType'])
            ?.toString()
            .toUpperCase();
        final url = (item['url'] ?? item['media_url'] ?? item['mediaUrl'])
            ?.toString();
        if (url == null || url.isEmpty) continue;
        if (type == 'VIDEO' || url.toLowerCase().contains('mp4'))
          videos.add(url);
      }
    }
    return videos;
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  Map<String, dynamic> _mapProfilePost(Map json) {
    return {
      'id': json['id'].toString(),
      'userId': json['user_id'].toString(),
      'body': json['content'] ?? '',
      'date': json['created_at'] ?? DateTime.now().toIso8601String(),

      'likes': 0,
      'repost': 0,
      'comments': 0,

      'username': json["username"],
      'authorName': json["name"],
      'authorProfileImage': json["avatar"],

      'mediaImages': [],
      'mediaVideos': [],

      'isRepost': false,
      'isQuote': false,
    };
  }
}
