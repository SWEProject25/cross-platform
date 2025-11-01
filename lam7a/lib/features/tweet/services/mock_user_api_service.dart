import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/core/models/user_model.dart';

part 'mock_user_api_service.g.dart';

final _mockUsers = {
  '1': UserModel(
    id: 1,
    username: 'johnd',
    email: 'john@example.com',
    name: 'John Doe',
    profileImageUrl: 'https://i.pravatar.cc/150?img=3',
    bio: 'Software Developer',
    location: 'New York',
    createdAt: DateTime.now().toIso8601String(),
  ),
  '2': UserModel(
    id: 2,
    username: 'sjane',
    email: 'sarah@example.com',
    name: 'Sarah Jane',
    profileImageUrl: 'https://i.pravatar.cc/150?img=5',
    bio: 'Designer',
    location: 'San Francisco',
    createdAt: DateTime.now().toIso8601String(),
  ),
};

@riverpod
Future<UserModel> userById(Ref ref, String id) async {
  //await Future.delayed(const Duration(milliseconds: 500)); // simulate latency
  return _mockUsers[id] ?? _mockUsers.values.first;
}
