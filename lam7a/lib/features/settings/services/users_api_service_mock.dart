import 'dart:async';
import 'users_api_service.dart';
import '../../../core/models/user_model.dart';

class UsersApiServiceMock implements UsersApiService {
  final List<UserModel> _mockMuted = [
    const UserModel(
      id: 1,
      username: '@john_doe',
      name: 'John Doe',
      bio:
          'Coffee lover ☕ pwenw pnej2pe jwpe jpwjempiwj epiwjmepwefowjipvwjefwmpejiwnej wmecjiwpnevjom wev',
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/147/147144.png',
    ),
    const UserModel(
      id: 2,
      username: '@jane_doe',
      name: 'Jane Doe',
      bio: 'Traveler ✈️ | Writer ✍️',
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/194/194938.png',
    ),
  ];

  final List<UserModel> _mockBlocked = [
    const UserModel(
      id: 3,
      username: '@mark_coder',
      name: 'Mark Coder',
      bio: 'Tech enthusiast 💻',
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/147/147140.png',
    ),
  ];

  @override
  Future<List<UserModel>> getMutedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<UserModel>.from(_mockMuted);
  }

  @override
  Future<List<UserModel>> getBlockedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<UserModel>.from(_mockBlocked);
  }

  @override
  Future<void> unmuteUser(int userId) async {
    _mockMuted.removeWhere((u) => u.id == userId);
  }

  @override
  Future<void> unblockUser(int userId) async {
    _mockBlocked.removeWhere((u) => u.id == userId);
  }
}
