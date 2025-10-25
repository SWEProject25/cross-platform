import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/tweet_summary/models/user_profile.dart';

part 'mock_user_provider.g.dart';

final _mockUsers = {
  '1': UserProf(
    id: '1',
    username: 'John Doe',
    hashUserName: '@johnd',
    profilePic: 'https://i.pravatar.cc/150?img=3',
  ),
  '2': UserProf(
    id: '2',
    username: 'Sarah Jane',
    hashUserName: '@sjane',
    profilePic: 'https://i.pravatar.cc/150?img=5',
  ),
};

@riverpod
Future<UserProf> userById(Ref ref, String userId) async {
  //await Future.delayed(const Duration(milliseconds: 500)); // simulate latency
  return _mockUsers[userId] ?? _mockUsers.values.first;
}
