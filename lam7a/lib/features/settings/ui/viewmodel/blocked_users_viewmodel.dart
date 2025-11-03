import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/user_releations_repository.dart';
import '../state/blocked_users_state.dart';

class BlockedUsersViewModel extends AsyncNotifier<BlockedUsersState> {
  late final UserRelationsRepository _repo;

  @override
  Future<BlockedUsersState> build() async {
    _repo = ref.read(userRelationsRepositoryProvider);
    final users = await _repo.fetchBlockedUsers();
    return BlockedUsersState(blockedUsers: users);
  }

  Future<void> unblockUser(int userId) async {
    final previousState = state.asData?.value;
    if (previousState == null) return;

    try {
      await _repo.unblockUser(userId);

      // Update the list only after success
      final updatedList = previousState.blockedUsers
          .where((user) => user.id != userId)
          .toList();

      // Keep isLoading false (you can use a separate field if you want a small spinner)
      state = AsyncData(previousState.copyWith(blockedUsers: updatedList));
    } catch (e, st) {
      // Keep the old data but reflect the error if needed
      state = AsyncError(e, st);
      state = AsyncData(previousState);
    }
  }
}

final blockedUsersProvider =
    AsyncNotifierProvider<BlockedUsersViewModel, BlockedUsersState>(
      BlockedUsersViewModel.new,
    );
