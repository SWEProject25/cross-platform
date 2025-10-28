import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/features/authentication/model/user_model.dart';

/// User API Service for fetching user information
class UserApiService {
  final Dio _dio;
  
  UserApiService({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: ApiConfig.currentBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
    ),
  );
  
  /// Get current authenticated user
  Future<UserModel> getCurrentUser() async {
    try {
      print('📥 Fetching current user from backend...');
      
      final response = await _dio.get('${ApiConfig.authEndpoint}/me');
      
      if (response.statusCode == 200) {
        final userData = response.data['data'];
        final user = UserModel.fromJson(userData);
        
        print('✅ Current user fetched: ${user.username} (ID: ${user.userId})');
        return user;
      } else {
        throw Exception('Failed to fetch current user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching current user: $e');
      // Return a default user for now
      print('   Using default user ID: 1');
      return const UserModel(
        userId: 1,
        username: 'default_user',
        email: 'user@example.com',
        displayName: 'Default User',
      );
    }
  }
  
  /// Get user by ID
  Future<UserModel> getUserById(int userId) async {
    try {
      print('📥 Fetching user $userId from backend...');
      
      final response = await _dio.get('${ApiConfig.usersEndpoint}/$userId/profile');
      
      if (response.statusCode == 200) {
        final userData = response.data['data'];
        final user = UserModel.fromJson(userData);
        
        print('✅ User fetched: ${user.username}');
        return user;
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching user: $e');
      rethrow;
    }
  }
  
  /// Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      print('📥 Searching users: $query');
      
      final response = await _dio.get(
        '${ApiConfig.usersEndpoint}/search',
        queryParameters: {'q': query},
      );
      
      if (response.statusCode == 200) {
        final users = (response.data['data'] as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
        
        print('✅ Found ${users.length} users');
        return users;
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching users: $e');
      return [];
    }
  }
}

/// Provider for UserApiService
final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService();
});

/// Provider for current user
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final service = ref.read(userApiServiceProvider);
  return service.getCurrentUser();
});
