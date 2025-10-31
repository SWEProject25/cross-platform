import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';

/// User API Service for fetching user information
/// Uses core ApiService following MVVM architecture
class UserApiService {
  final ApiService _apiService;
  
  UserApiService({required ApiService apiService}) 
      : _apiService = apiService;
  
  /// Get current authenticated user
  Future<UserModel> getCurrentUser() async {
    try {
      print('📥 Fetching current user from backend...');
      
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.authEndpoint}/me',
      );
      
      final userData = response['data'];
      final user = UserModel.fromJson(userData);
      
      print('✅ Current user fetched: ${user.username}');
      return user;
    } catch (e) {
      print('❌ Error fetching current user: $e');
      // Return a default user for now
      print('   Using default user ID: 1');
      return const UserModel(
        username: 'default_user',
        email: 'user@example.com',
        name: 'Default User',
      );
    }
  }
  
  /// Get user by ID
  /// Note: Backend returns user info embedded in posts, not a separate user endpoint
  /// This fetches user profile posts to extract user information
  Future<UserModel> getUserById(int userId) async {
    try {
      print('📥 Fetching user $userId from backend...');
      
      // Backend doesn't have /users/:id/profile endpoint
      // Instead, we fetch user's posts which include user info
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/profile/$userId',
        queryParameters: {'limit': 1}, // Just need one post to get user info
      );
      
      final posts = response['data'] as List;
      if (posts.isNotEmpty) {
        final firstPost = posts[0];
        // Extract user info from post data
        final userData = {
          'userId': userId.toString(),
          'username': firstPost['username'],
          'name': firstPost['authorName'] ?? firstPost['username'],
          'profileImageUrl': firstPost['authorProfileImage'],
        };
        final user = UserModel.fromJson(userData);
        
        print('✅ User fetched: ${user.username}');
        return user;
      }
      
      // If user has no posts, return basic user info
      return UserModel(
        userId: userId.toString(),
        username: 'user_$userId',
        name: 'User $userId',
      );
    } catch (e) {
      print('❌ Error fetching user: $e');
      rethrow;
    }
  }
  
  /// Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      print('📥 Searching users: $query');
      
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.usersEndpoint}/search',
        queryParameters: {'q': query},
      );
      
      final users = (response['data'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      
      print('✅ Found ${users.length} users');
      return users;
    } catch (e) {
      print('❌ Error searching users: $e');
      return [];
    }
  }
}

/// Provider for UserApiService
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserApiService(apiService: apiService);
});

/// Provider for current user
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final service = ref.read(userApiServiceProvider);
  return service.getCurrentUser();
});
