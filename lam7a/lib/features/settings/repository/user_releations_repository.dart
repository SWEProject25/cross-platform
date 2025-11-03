import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import '../services/users_api_service.dart';

part 'user_releations_repository.g.dart';

@riverpod
UserRelationsRepository userRelationsRepository(Ref ref) {
  return UserRelationsRepository(ref.read(usersApiServiceProvider));
}

class UserRelationsRepository {
  final UsersApiService _api;

  UserRelationsRepository(this._api);

  Future<List<UserModel>> fetchMutedUsers() => _api.getMutedUsers();
  Future<List<UserModel>> fetchBlockedUsers() => _api.getBlockedUsers();

  Future<void> unmuteUser(int userId) => _api.unmuteUser(userId);
  Future<void> unblockUser(int userId) => _api.unblockUser(userId);
}
