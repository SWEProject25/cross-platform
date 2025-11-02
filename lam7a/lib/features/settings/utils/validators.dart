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
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'\d'));
    final hasSpecial = password.contains(RegExp(r'[\W_]'));

    final strengthCriteria = [
      hasUppercase,
      hasLowercase,
      hasNumber,
      hasSpecial,
    ];
    final metCriteria = strengthCriteria.where((criteria) => criteria).length;

    switch (metCriteria) {
      case 1:
        return PasswordStrength.weak;
      case 2:
        return PasswordStrength.medium;
      case 3:
        return PasswordStrength.strong;
      case 4:
        return PasswordStrength.veryStrong;
      default:
        return PasswordStrength.weak;
    }
  }
}
