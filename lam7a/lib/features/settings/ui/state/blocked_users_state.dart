import '../../../../core/models/user_model.dart';

class BlockedUsersState {
  final List<UserModel> blockedUsers;

  const BlockedUsersState({this.blockedUsers = const []});

  BlockedUsersState copyWith({List<UserModel>? blockedUsers}) {
    return BlockedUsersState(blockedUsers: blockedUsers ?? this.blockedUsers);
  }
}
