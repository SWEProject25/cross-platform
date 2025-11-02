enum ChangeEmailPage { verifyPassword, changeEmail, verifyOtp }

class ChangeEmailState {
  final ChangeEmailPage currentPage;
  final String password;
  final String email;
  final String otp;

  const ChangeEmailState({
    this.currentPage = ChangeEmailPage.verifyPassword,
    this.password = '',
    this.email = '',
    this.otp = '',
  });

  ChangeEmailState copyWith({
    ChangeEmailPage? currentPage,
    String? password,
    String? email,
    String? otp,
  }) {
    return ChangeEmailState(
      currentPage: currentPage ?? this.currentPage,
      password: password ?? this.password,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  // @override
  // List<Object?> get props => [currentPage, password, email];
}
