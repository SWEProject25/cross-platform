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
  bool validateName(String name) {
  final regex = RegExp(r"^[a-zA-Z\u0080-\uFFFF' -]+$");
  return name.isNotEmpty && regex.hasMatch(name);
  }

  bool validateDate(String date) {
    return (date.isNotEmpty);
  }

  bool validateCode(String code) {
    return (code.length == 6);
  }
bool validatePassword(String password) {
  final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,50}$');
  return regex.hasMatch(password);
}

String validationErrors(String password) {
  if (password.isEmpty) {
    return 'Password cannot be empty';
  }

  List<String> errors = [];

  if (password.length < 8) {
    errors.add('Password must be at least 8 characters long');
    return errors.join();
  } else if (password.length > 50) {
    errors.add('Password must not exceed 50 characters');
    return errors.join();
  }
  errors.add("password must contain");
  

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    errors.add('at least one uppercase letter (A-Z)');
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    errors.add('at least one lowercase letter (a-z)');
  }

  if (!RegExp(r'\d').hasMatch(password)) {
    errors.add('at least one digit (0-9)');
  }

  if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
    errors.add('at least one special character (@, \$, !, %, *, ?, &)');
  }

  if (RegExp(r'[^A-Za-z\d@$!%*?&]').hasMatch(password)) {
    errors.add('Password contains invalid characters. Only letters, digits, and @\$!%*?& are allowed');
  }

  if (errors.length == 1) {
    return '';
  } else {
    return errors.join(', ');
  }
}

}
