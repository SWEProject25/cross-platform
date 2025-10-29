import 'dart:async';
import '../models/users_model.dart';
import 'users_api_service.dart';

class UsersApiServiceMock implements UsersApiService {
  final List<User> _mockMuted = [
    const User(
      id: '1',
      handle: '@john_doe',
      displayName: 'John Doe',
      bio: 'Coffee lover ☕',
      profilePic: 'https://cdn-icons-png.flaticon.com/512/147/147144.png',
    ),
    const User(
      id: '2',
      handle: '@jane_doe',
      displayName: 'Jane Doe',
      bio: 'Traveler ✈️ | Writer ✍️',
      profilePic: 'https://cdn-icons-png.flaticon.com/512/194/194938.png',
    ),
  ];

  final List<User> _mockBlocked = [
    const User(
      id: '3',
      handle: '@mark_coder',
      displayName: 'Mark Coder',
      bio: 'Tech enthusiast 💻',
      profilePic: 'https://cdn-icons-png.flaticon.com/512/147/147140.png',
    ),
  ];

  @override
  Future<List<User>> getMutedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<User>.from(_mockMuted);
  }

  @override
  Future<List<User>> getBlockedUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<User>.from(_mockBlocked);
  }

  @override
  Future<void> unmuteUser(String userId) async {
    _mockMuted.removeWhere((u) => u.id == userId);
  }

  @override
  Future<void> unblockUser(String userId) async {
    _mockBlocked.removeWhere((u) => u.id == userId);
  }
}
