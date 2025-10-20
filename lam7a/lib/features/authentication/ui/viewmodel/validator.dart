class Validator {
  bool isValidPasswordSignup;
  bool isValidEmailSignup;
  bool isValidNameSignup;
  bool isValidCodeSignup;
  bool isValidUsernameSignup;
  bool isValidDateSignup;
  Validator({
    this.isValidCodeSignup = false,
    this.isValidDateSignup = false,
    this.isValidEmailSignup = false,
    this.isValidPasswordSignup = false,
    this.isValidNameSignup = false,
    this.isValidUsernameSignup = false,
  });
  bool validateEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return (password.length >= 8);
  }

  bool validateName(String name) {
    return (name.length >= 3);
  }

  bool validateDate(String date) {
    return (!date.isEmpty);
  }

  bool validateCode(String code) {
    return (code.length == 6);
  }
}
