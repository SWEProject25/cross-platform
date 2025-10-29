import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/api/authenticated_dio_provider.dart';

/// Service for handling post interactions (likes, reposts, etc.)
/// According to API spec:
/// - POST /posts/{postId}/like - Toggle like
/// - GET /posts/{postId}/likers - Get list of likers (count in metadata)
/// - POST /posts/{postId}/repost - Toggle repost  
/// - GET /posts/{postId}/reposters - Get list of reposters (count in metadata)
class PostInteractionsService {
  final Dio _dio;

  PostInteractionsService(this._dio);

  /// Toggle like on a post
  /// Returns true if liked, false if unliked
  Future<bool> toggleLike(String postId) async {
    try {
      print('❤️  Toggling like on post: $postId');
      
      final response = await _dio.post(
        '${ApiConfig.postsEndpoint}/$postId/like',
      );
      
      if (response.statusCode == 200) {
        final message = response.data['message'] as String?;
        final isLiked = message?.toLowerCase().contains('liked') ?? false;
        print('   ${isLiked ? "✅ Liked" : "❌ Unliked"}');
        return isLiked;
      }
      return false;
    } catch (e) {
      print('❌ Error toggling like: $e');
      rethrow;
    }
  }

  /// Get count of likes on a post
  /// Note: Backend doesn't return total count, we get array length as approximation
  Future<int> getLikesCount(String postId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.postsEndpoint}/$postId/likers',
        queryParameters: {'limit': 100, 'page': 1}, // Get more to estimate count
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          return data.length;
        }
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

  /// Toggle repost on a post
  /// Returns true if reposted, false if un-reposted
  Future<bool> toggleRepost(String postId) async {
    try {
      print('🔁 Toggling repost on post: $postId');
      
      final response = await _dio.post(
        '${ApiConfig.postsEndpoint}/$postId/repost',
      );
      
      if (response.statusCode == 200) {
        final message = response.data['message'] as String?;
        final isReposted = message?.toLowerCase().contains('repost') ?? false;
        print('   ${isReposted ? "✅ Reposted" : "❌ Un-reposted"}');
        return isReposted;
      }
      return false;
    } catch (e) {
      print('❌ Error toggling repost: $e');
      rethrow;
    }
  }

  /// Get count of reposts on a post
  /// Note: Backend doesn't return total count, we get array length as approximation
  Future<int> getRepostsCount(String postId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.postsEndpoint}/$postId/reposters',
        queryParameters: {'limit': 100, 'page': 1}, // Get more to estimate count
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          return data.length;
        }
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
}

/// Provider for PostInteractionsService
final postInteractionsServiceProvider = FutureProvider<PostInteractionsService>((ref) async {
  final dio = await ref.watch(authenticatedDioProvider.future);
  return PostInteractionsService(dio);
});
