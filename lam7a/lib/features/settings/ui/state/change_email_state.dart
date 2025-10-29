enum ChangeEmailPage { verifyPassword, changeEmail }

class ChangeEmailState {
  final ChangeEmailPage currentPage;
  final String password;
  final String email;

  const ChangeEmailState({
    this.currentPage = ChangeEmailPage.verifyPassword,
    this.password = '',
    this.email = '',
  });

  ChangeEmailState copyWith({
    ChangeEmailPage? currentPage,
    String? password,
    String? email,
  }) {
    return ChangeEmailState(
      currentPage: currentPage ?? this.currentPage,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  // @override
  // List<Object?> get props => [currentPage, password, email];
}
