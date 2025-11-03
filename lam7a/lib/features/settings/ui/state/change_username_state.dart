class ChangeUsernameState {
  final String currentUsername;
  final String newUsername;
  final bool isValid;
  final bool isLoading;

  const ChangeUsernameState({
    this.currentUsername = '@mohamed33063545',
    this.newUsername = '',
    this.isValid = false,
    this.isLoading = false,
  });

  ChangeUsernameState copyWith({
    String? currentUsername,
    String? newUsername,
    bool? isValid,
    bool? isLoading,
  }) {
    return ChangeUsernameState(
      currentUsername: currentUsername ?? this.currentUsername,
      newUsername: newUsername ?? this.newUsername,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
