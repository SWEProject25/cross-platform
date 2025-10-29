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
 
  final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
  return regex.hasMatch(password);
}
  bool validateName(String name) {
    return (name.length >= 3);
  }

  bool validateDate(String date) {
    return (date.isNotEmpty);
  }

  bool validateCode(String code) {
    return (code.length == 6);
  }
}
