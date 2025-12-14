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
  // 1. Trim leading and trailing spaces
  final sanitizedEmail = email.trim();

  if (sanitizedEmail.isEmpty) return false;

  // Never touched this as requested
  final asciiRegex = RegExp(
    r'^[\u0020-\u007E]+$',
  );

  if (!asciiRegex.hasMatch(sanitizedEmail)) return false;

  final emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  return emailRegex.hasMatch(sanitizedEmail);
}

bool validateName(String name) {
  if (name != name.trim()) {
    return false;
  }

  if (name.isEmpty) {
    return false;
  }

  final regex = RegExp(
    r"^[\p{L}\p{M}' -]+$",
    unicode: true,
  );

  return regex.hasMatch(name);  
}
  bool validateDate(String date) {
    // Return false if there are leading or trailing spaces
    if (date != date.trim()) {
      return false;
    }
    
    return date.isNotEmpty;
  }

  bool validateCode(String code) {
    // Return false if there are leading or trailing spaces
    if (code != code.trim()) {
      return false;
    }
    
    return code.length == 6;
  }
  
  bool validatePassword(String password) {
    // Return false if there are leading or trailing spaces
    if (password != password.trim()) {
      return false;
    }
    
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,50}$');
    return regex.hasMatch(password);
  }

String validationErrors(String password) {
  if (password.isEmpty) {
    return 'Password cannot be empty';
  }

  List<String> errors = [];
  // 2. Length Checks
  if (password.length < 8) {
    errors.add('Password must be at least 8 characters long');
  } else if (password.length > 50) {
    errors.add('Password must not exceed 50 characters');
  }

  // 3. Character Requirements
  List<String> requirements = [];
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    requirements.add('an uppercase letter (A-Z)');
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    requirements.add('a lowercase letter (a-z)');
  }
  if (!RegExp(r'\d').hasMatch(password)) {
    requirements.add('a digit (0-9)');
  }
  if (!RegExp(r'[@$!%*?&]').hasMatch(password)) {
    requirements.add('a special character (@, \$, !, %, *, ?, &)');
  }

  // Add character requirements to main errors list if any are missing
  if (requirements.isNotEmpty) {
    errors.add('Password must contain ${requirements.join(', ')}');
  }

  // 4. Invalid Characters Check
  if (RegExp(r'[^A-Za-z\d@$!%*?&]').hasMatch(password)) {

    errors.add('Password contains invalid characters (only letters, digits, and @\$!%*?& are allowed)');
  }

  if (errors.isEmpty) {
    return '';
  } else {
    String result = errors.join('; ');
    return result[0].toUpperCase() + result.substring(1);
  }
}
}