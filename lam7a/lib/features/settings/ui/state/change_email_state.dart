enum ChangeEmailPage { verifyPassword, changeEmail, verifyOtp }

class ChangeEmailState {
  final ChangeEmailPage currentPage;
  final String password;
  final String email;
  final String otp;
  final bool isLoading;

  const ChangeEmailState({
    this.currentPage = ChangeEmailPage.verifyPassword,
    this.password = '',
    this.email = '',
    this.isLoading = false,
    this.otp = '',
  });

  ChangeEmailState copyWith({
    ChangeEmailPage? currentPage,
    String? password,
    String? email,
    String? otp,
    bool? isLoading,
  }) {
    return ChangeEmailState(
      currentPage: currentPage ?? this.currentPage,
      password: password ?? this.password,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // @override
  // List<Object?> get props => [currentPage, password, email];
}
