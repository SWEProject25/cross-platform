import '../../models/users_model.dart';

class BlockedUsersState {
  final List<User> blockedUsers;
  final bool isLoading;

  const BlockedUsersState({
    this.blockedUsers = const [],
    this.isLoading = false,
  });

  BlockedUsersState copyWith({List<User>? blockedUsers, bool? isLoading}) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
