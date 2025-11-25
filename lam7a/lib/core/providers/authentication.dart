import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication.g.dart';

// this is under developing not finished yet
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  late ApiService _apiService;
  @override
  AuthState build() {
    _apiService = ref.read(apiServiceProvider);
    return AuthState();
  }

  Future<void> isAuthenticated() async {
    try {
      final response = await _apiService.get(endpoint: ServerConstant.profileMe);
      if (response['data'] != null) {
        UserDtoAuth user =  UserDtoAuth.fromJson(response['data']);
        print("this is my user ${user}");
        authenticateUser(user);
      }
    } catch (e) {
      print(e);
    }
  }
UserModel userDtoToUserModel(UserDtoAuth dto) {
  return UserModel(
    id: dto.id,
    username: dto.user.username,
    email: dto.user.email,
    role: dto.user.role,
    name: dto.name,
    birthDate: dto.birthDate.toIso8601String(),
    profileImageUrl: dto.profileImageUrl?.toString(),
    bannerImageUrl: dto.bannerImageUrl?.toString(),
    bio: dto.bio?.toString(),
    location: dto.location?.toString(),
    website: dto.website?.toString(),
    createdAt: dto.createdAt.toIso8601String(),
    followersCount: dto.followersCount,
    followingCount: dto.followingCount
  );
}

  void authenticateUser(UserDtoAuth? user) {
    
    if (user != null) {
      UserModel userModel = userDtoToUserModel(user);
      state = state.copyWith(token: null, isAuthenticated: true, user: userModel);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await _apiService.post(endpoint: ServerConstant.logout);
      if (response['message'] == 'Logout successful') {
        prefs.remove('token');
        state = state.copyWith(user: null, isAuthenticated: false);
      } else {
        print("Logout failed");
      }
    } catch (e) {
      print(e);
    }
  }
}
