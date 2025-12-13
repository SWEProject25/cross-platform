import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/models/user_model.dart';

/// Service for handling post interactions (likes, reposts, etc.)
/// Uses authenticated Dio from core with ApiConfig endpoints
/// According to API spec:
/// - POST /posts/{postId}/like - Toggle like
/// - GET /posts/{postId}/likers - Get list of likers (count in metadata)
/// - POST /posts/{postId}/repost - Toggle repost  
/// - GET /posts/{postId}/reposters - Get list of reposters (count in metadata)
class PostInteractionsService {
  final ApiService _apiService;

  PostInteractionsService(this._apiService);

  /// Toggle like on a post
  /// Returns true if liked, false if unliked
  Future<bool> toggleLike(String postId) async {
    try {
      print('❤️  Toggling like on post: $postId');
      
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/like',
      );

      // Prefer the explicit boolean flag from backend: data.liked
      bool? likedFlag;
      final data = response['data'];
      if (data is Map && data['liked'] != null) {
        likedFlag = data['liked'] == true;
      } else if (response['liked'] != null) {
        // Fallback in case the backend returns liked at the top level
        likedFlag = response['liked'] == true;
      }

      if (likedFlag != null) {
        print('   Backend liked flag: $likedFlag');
        return likedFlag;
      }

      // Fallback: infer from human-readable message for older backends
      final message = response['message'] as String?;
      final messageLower = message?.toLowerCase() ?? '';

      // Check for 'unliked' first since 'unliked' contains 'liked'
      final isLiked =
          !messageLower.contains('unliked') && messageLower.contains('liked');

      print('   Message: "$message"');
      print('   ${isLiked ? "✅ Liked" : "❌ Unliked"}');
      return isLiked;
    } catch (e) {
      print('❌ Error toggling like: $e');
      rethrow;
    }
  }

  /// Get count of likes on a post
  /// Note: Backend doesn't return total count, we get array length as approximation
  Future<int> getLikesCount(String postId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/likers',
        queryParameters: {'limit': 100, 'page': 1}, // Get more to estimate count
      );
      
      final data = response['data'];
      if (data is List) {
        return data.length;
      }
      return 0;
    } on DioException catch (e) {
      // Backend doesn't have this endpoint yet (404) or other errors
      if (e.response?.statusCode == 404) {
        print('   ℹ️ Likers endpoint not available (404), using 0');
        return 0;
      }
      print('❌ Error fetching likes count: $e');
      return 0;
    } catch (e) {
      print('❌ Error fetching likes count: $e');
      return 0;
    }
  }

  /// Get list of users who liked a post (for UI display)
  /// Uses the same /likers endpoint but maps the response into UserModel objects
  Future<List<UserModel>> getLikers(
    String postId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/likers',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final data = response['data'];
      List<UserModel> users = [];

      if (data is List) {
        users = data
            .whereType<Map>()
            .map(
              (item) => _mapInteractionUser(
                item.cast<String, dynamic>(),
              ),
            )
            .toList();
      } else if (data is Map) {
        final inner = data['data'] ?? data['users'] ?? data['likers'];
        if (inner is List) {
          users = inner
              .whereType<Map>()
              .map(
                (item) => _mapInteractionUser(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList();
        }
      }

      return users;
    } on DioException catch (e) {
      // Backend might not expose this endpoint in some environments
      if (e.response?.statusCode == 404) {
        print('   ℹ️ Likers endpoint not available (404), returning empty list');
        return [];
      }
      print('❌ Error fetching likers: $e');
      return [];
    } catch (e) {
      print('❌ Error fetching likers: $e');
      return [];
    }
  }

  /// Get list of users who reposted a post (for UI display)
  /// Uses the /reposters endpoint and maps the response into UserModel objects
  Future<List<UserModel>> getReposters(
    String postId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/reposters',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final data = response['data'];
      List<UserModel> users = [];

      if (data is List) {
        users = data
            .whereType<Map>()
            .map(
              (item) => _mapInteractionUser(
                item.cast<String, dynamic>(),
              ),
            )
            .toList();
      } else if (data is Map) {
        final inner = data['data'] ?? data['users'] ?? data['reposters'];
        if (inner is List) {
          users = inner
              .whereType<Map>()
              .map(
                (item) => _mapInteractionUser(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList();
        }
      }

      return users;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('   ℹ️ Reposters endpoint not available (404), returning empty list');
        return [];
      }
      print('❌ Error fetching reposters: $e');
      return [];
    } catch (e) {
      print('❌ Error fetching reposters: $e');
      return [];
    }
  }

  /// Toggle repost on a post
  /// Returns true if reposted, false if un-reposted
  Future<bool> toggleRepost(String postId) async {
    try {
      print('🔁 Toggling repost on post: $postId');
      
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/repost',
      );
      
      final message = response['message'] as String?;
      final messageLower = message?.toLowerCase() ?? '';
      
      // Check for 'unrepost' or 'removed' first
      final isReposted = !messageLower.contains('unrepost') && 
                        !messageLower.contains('removed') && 
                        messageLower.contains('repost');
      
      print('   ${isReposted ? "✅ Reposted" : "❌ Un-reposted"}');
      return isReposted;
    } catch (e) {
      print('❌ Error toggling repost: $e');
      rethrow;
    }
  }

  /// Get count of reposts on a post
  /// Note: Backend doesn't return total count, we get array length as approximation
  Future<int> getRepostsCount(String postId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/reposters',
        queryParameters: {'limit': 100, 'page': 1}, // Get more to estimate count
      );
      
      final data = response['data'];
      if (data is List) {
        return data.length;
      }
      return 0;
    } on DioException catch (e) {
      // Backend doesn't have this endpoint yet (404) or other errors
      if (e.response?.statusCode == 404) {
        print('   ℹ️ Reposters endpoint not available (404), using 0');
        return 0;
      }
      print('❌ Error fetching reposts count: $e');
      return 0;
    } catch (e) {
      print('❌ Error fetching reposts count: $e');
      return 0;
    }
  }

  /// Check if current user has liked a post
  /// Returns true if the current user is in the likers list
  Future<bool> isLikedByCurrentUser(String postId, int currentUserId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/likers',
        queryParameters: {'limit': 100, 'page': 1},
      );
      
      final data = response['data'];
      if (data is List) {
        // Check if current user ID is in the likers list
        return data.any((liker) => liker['id'] == currentUserId);
      }
      return false;
    } catch (e) {
      print('   ⚠️ Error checking if liked: $e');
      return false;
    }
  }
  
  /// Check if current user has reposted a post
  /// Returns true if the current user is in the reposters list
  Future<bool> isRepostedByCurrentUser(String postId, int currentUserId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/$postId/reposters',
        queryParameters: {'limit': 100, 'page': 1},
      );
      
      final data = response['data'];
      if (data is List) {
        // Check if current user ID is in the reposters list
        return data.any((reposter) => reposter['id'] == currentUserId);
      }
      return false;
    } catch (e) {
      print('   ⚠️ Error checking if reposted: $e');
      return false;
    }
  }

  /// Get counts for a post (likes and reposts)
  Future<Map<String, int>> getPostCounts(String postId) async {
    try {
      final results = await Future.wait([
        getLikesCount(postId),
        getRepostsCount(postId),
      ]);
      
      return {
        'likes': results[0],
        'reposts': results[1],
      };
    } catch (e) {
      print('❌ Error fetching post counts: $e');
      return {'likes': 0, 'reposts': 0};
    }
  }

  UserModel _mapInteractionUser(Map<String, dynamic> raw) {
    final Map<String, dynamic> base;
    if (raw['user'] is Map) {
      base = (raw['user'] as Map).cast<String, dynamic>();
    } else {
      base = raw;
    }

    final dynamic rawId = base['id'];
    int? id;
    if (rawId is int) {
      id = rawId;
    } else if (rawId is String) {
      id = int.tryParse(rawId);
    }

    final avatar = base['profileImageUrl'] ??
        base['avatar'] ??
        base['profile_image_url'];

    return UserModel(
      id: id,
      username: base['username'] as String?,
      email: base['email'] as String?,
      name: base['name'] as String?,
      profileImageUrl: avatar as String?,
    );
  }
}

/// Provider for PostInteractionsService
final postInteractionsServiceProvider = Provider<PostInteractionsService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PostInteractionsService(apiService);
});
