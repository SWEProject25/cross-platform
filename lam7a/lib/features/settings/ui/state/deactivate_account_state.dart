enum DeactivateAccountPage { main, confirm }

class DeactivateAccountState {
  final DeactivateAccountPage currentPage;
  final String password;
  final bool isHoldingButton;

  const DeactivateAccountState({
    this.currentPage = DeactivateAccountPage.main,
    this.password = '',
    this.isHoldingButton = false,
  });

  DeactivateAccountState copyWith({
    DeactivateAccountPage? currentPage,
    String? password,
    bool? isHoldingButton,
  }) {
    return DeactivateAccountState(
      currentPage: currentPage ?? this.currentPage,
      password: password ?? this.password,
      isHoldingButton: isHoldingButton ?? this.isHoldingButton,
    );
  }
}
