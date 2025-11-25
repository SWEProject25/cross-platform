class ChangeUsernameState {
  final String currentUsername;
  final String newUsername;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const ChangeUsernameState({
    this.currentUsername = '@mohamed33063545',
    this.newUsername = '',
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  ChangeUsernameState copyWith({
    String? currentUsername,
    String? newUsername,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChangeUsernameState(
      currentUsername: currentUsername ?? this.currentUsername,
      newUsername: newUsername ?? this.newUsername,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
