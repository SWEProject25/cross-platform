import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_to_follow_viewmodel.g.dart';

@riverpod
class UsersToFollowViewmodel extends _$UsersToFollowViewmodel {
  Future<List<UserToFollowDto>> build() async {
    final repo = ref.read(authenticationImplRepositoryProvider);
    return await repo.getUsersToFollow();
  }

  Future<void> followUser(int userId) async {
    final repo = ref.read(authenticationImplRepositoryProvider);
    bool check = await repo.followUser(userId);
    state = AsyncData(
      state.value!.map((user) {
        if (user.id == userId) {
          return user.copyWith(isFollowing: true); // You need a copyWith method
        }
        return user;
      }).toList(),
    );
  }

  Future<void> unfollowUser(int userId) async {
    // Implement unfollow logic if needed
    final repo = ref.read(authenticationImplRepositoryProvider);
    bool check = await repo.unFollowUser(userId);
    state = AsyncData(
      state.value!.map((user) {
        if (user.id == userId) {
          return user.copyWith(isFollowing: false);
        }
        return user;
      }).toList(),
    );
  }
}
