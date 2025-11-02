import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import '../services/users_api_service.dart';

part 'users_repository.g.dart';

@riverpod
UserRelationsRepository usersRepository(Ref ref) {
  return UserRelationsRepository(ref.read(usersApiServiceProvider));
}

class UserRelationsRepository {
  final UsersApiService _api;

  UserRelationsRepository(this._api);

  Future<List<UserModel>> fetchMutedUsers() => _api.getMutedUsers();
  Future<List<UserModel>> fetchBlockedUsers() => _api.getBlockedUsers();

  Future<void> unmuteUser(String userId) => _api.unmuteUser(userId);
  Future<void> unblockUser(String userId) => _api.unblockUser(userId);
}
