class AccountModel {
  String handle;
  String email;
  String country;
  String password; // only for testing purposes

  AccountModel({
    required this.handle,
    required this.email,
    required this.country,
    required this.password,
  });

  AccountModel copyWith({
    String? handle,
    String? email,
    String? country,
    String? password,
  }) {
    return AccountModel(
      handle: handle ?? this.handle,
      email: email ?? this.email,
      country: country ?? this.country,
      password: password ?? this.password,
    );
  }
}
