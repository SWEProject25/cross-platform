enum PasswordStrength { weak, medium, strong, veryStrong }

class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // At least 8 characters, one uppercase, one lowercase, one number, one special character
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static PasswordStrength getPasswordStrength(String password) {
    // Rule 1: too short
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    // Count occurrences of each type
    final upperCount = RegExp(r'[A-Z]').allMatches(password).length;
    final lowerCount = RegExp(r'[a-z]').allMatches(password).length;
    final numberCount = RegExp(r'\d').allMatches(password).length;
    final specialCount = RegExp(r'[\W_]').allMatches(password).length;

    // Rule 4: at least two of each → very strong
    if (upperCount >= 2 &&
        lowerCount >= 2 &&
        numberCount >= 2 &&
        specialCount >= 2) {
      return PasswordStrength.veryStrong;
    }

    // Rule 3: at least one of each → strong
    if (upperCount >= 1 &&
        lowerCount >= 1 &&
        numberCount >= 1 &&
        specialCount >= 1) {
      return PasswordStrength.strong;
    }

    // Rule 2: length ok but missing something → medium
    return PasswordStrength.medium;
  }
}
