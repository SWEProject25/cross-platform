class BlockedUserError implements Exception {
  final String message;

  BlockedUserError([this.message = 'You have been blocked by this user.']);

  @override
  String toString() => 'BlockedUserError: $message';
}