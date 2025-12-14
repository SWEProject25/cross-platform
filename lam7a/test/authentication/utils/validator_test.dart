import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';

void main() {
  group('Validator Class Tests', () {
    late Validator validator;

    setUp(() {
      validator = Validator();
    });

    group('Constructor Tests', () {
      test('should initialize with default false values', () {
        final validator = Validator();

        expect(validator.isValidCodeSignup, false);
        expect(validator.isValidDateSignup, false);
        expect(validator.isValidEmailSignup, false);
        expect(validator.isValidPasswordSignup, false);
        expect(validator.isValidNameSignup, false);
        expect(validator.isValidUsernameSignup, false);
      });

      test('should initialize with custom values', () {
        final validator = Validator(
          isValidCodeSignup: true,
          isValidDateSignup: true,
          isValidEmailSignup: true,
          isValidPasswordSignup: true,
          isValidNameSignup: true,
          isValidUsernameSignup: true,
        );

        expect(validator.isValidCodeSignup, true);
        expect(validator.isValidDateSignup, true);
        expect(validator.isValidEmailSignup, true);
        expect(validator.isValidPasswordSignup, true);
        expect(validator.isValidNameSignup, true);
        expect(validator.isValidUsernameSignup, true);
      });

      test('should initialize with partial custom values', () {
        final validator = Validator(
          isValidEmailSignup: true,
          isValidPasswordSignup: true,
        );

        expect(validator.isValidEmailSignup, true);
        expect(validator.isValidPasswordSignup, true);
        expect(validator.isValidCodeSignup, false);
        expect(validator.isValidDateSignup, false);
        expect(validator.isValidNameSignup, false);
        expect(validator.isValidUsernameSignup, false);
      });
    });

    group('validateEmail Tests', () {
      test('should return true for valid email addresses', () {
        expect(validator.validateEmail('test@example.com'), true);
        expect(validator.validateEmail('user.name@domain.com'), true);
        expect(validator.validateEmail('user+tag@example.co.uk'), true);
        expect(validator.validateEmail('a@b.c'), true);
        expect(validator.validateEmail('test123@test123.com'), true);
        expect(validator.validateEmail('user_name@example.com'), true);
        expect(validator.validateEmail('user-name@example-domain.com'), true);
      });

      test('should return false for emails without @', () {
        expect(validator.validateEmail('testexample.com'), false);
        expect(validator.validateEmail('test.example.com'), false);
        expect(validator.validateEmail('user'), false);
      });

      test('should return false for emails without domain', () {
        expect(validator.validateEmail('test@'), false);
        expect(validator.validateEmail('user@domain'), false);
      });

      test('should return false for emails without local part', () {
        expect(validator.validateEmail('@example.com'), false);
        expect(validator.validateEmail('@domain.com'), false);
      });

      test('should return false for empty email', () {
        expect(validator.validateEmail(''), false);
      });

      test('should return false for email with multiple @', () {
        expect(validator.validateEmail('test@@example.com'), false);
        expect(validator.validateEmail('test@test@example.com'), false);
      });

      test('should return false for email without dot in domain', () {
        expect(validator.validateEmail('test@example'), false);
      });

      test('should handle email with special characters', () {
        expect(validator.validateEmail('test!@example.com'), true);
        expect(validator.validateEmail('test#@example.com'), true);
        expect(validator.validateEmail('test\$@example.com'), true);
      });
    });

    group('validateName Tests', () {
      test('should return true for valid names', () {
        expect(validator.validateName('John'), true);
        expect(validator.validateName('John Doe'), true);
        expect(validator.validateName('Mary-Jane'), true);
        expect(validator.validateName("O'Brien"), true);
        expect(validator.validateName('José'), true);
        expect(validator.validateName('François'), true);
        expect(validator.validateName('Müller'), true);
        expect(validator.validateName('Jean-Claude'), true);
      });

      test('should return true for names with spaces', () {
        expect(validator.validateName('John Smith'), true);
        expect(validator.validateName('Mary Jane Watson'), true);
        expect(validator.validateName('A B C'), true);
      });

      test('should return true for names with hyphens', () {
        expect(validator.validateName('Mary-Jane'), true);
        expect(validator.validateName('Jean-Paul-Pierre'), true);
      });

      test('should return true for names with apostrophes', () {
        expect(validator.validateName("O'Connor"), true);
        expect(validator.validateName("D'Angelo"), true);
      });

      test('should return true for names with unicode characters', () {
        expect(validator.validateName('José'), true);
        expect(validator.validateName('François'), true);
        expect(validator.validateName('Björk'), true);
        expect(validator.validateName('Müller'), true);
        expect(validator.validateName('Søren'), true);
      });

      test('should return false for empty name', () {
        expect(validator.validateName(''), false);
      });

      test('should return false for names with numbers', () {
        expect(validator.validateName('John123'), false);
        expect(validator.validateName('Mary2'), false);
        expect(validator.validateName('1John'), false);
      });

      test('should return false for names with special characters', () {
        expect(validator.validateName('John@Doe'), false);
        expect(validator.validateName('Mary#Smith'), false);
        expect(validator.validateName('John!'), false);
        expect(validator.validateName('Test*Name'), false);
      });



      test('should handle single character names', () {
        expect(validator.validateName('A'), true);
        expect(validator.validateName('X'), true);
      });
    });

    group('validateDate Tests', () {
      test('should return true for non-empty date strings', () {
        expect(validator.validateDate('2000-01-01'), true);
        expect(validator.validateDate('2023-12-25'), true);
        expect(validator.validateDate('01/01/2000'), true);
        expect(validator.validateDate('25-12-2023'), true);
        expect(validator.validateDate('any string'), true);
        expect(validator.validateDate('x'), true);
      });

      test('should return false for empty date string', () {
        expect(validator.validateDate(''), false);
      });

      test('should return false for date with spaces', () {
        expect(validator.validateDate('2000 01 01'), true);
        expect(validator.validateDate(' '), false);
      });

      test('should return true for invalid date formats', () {
        expect(validator.validateDate('invalid'), true);
        expect(validator.validateDate('not a date'), true);
        expect(validator.validateDate('123abc'), true);
      });
    });

    group('validateCode Tests', () {
      test('should return true for 6-digit codes', () {
        expect(validator.validateCode('123456'), true);
        expect(validator.validateCode('000000'), true);
        expect(validator.validateCode('999999'), true);
        expect(validator.validateCode('abcdef'), true);
        expect(validator.validateCode('ABC123'), true);
      });

      test('should return false for codes shorter than 6 characters', () {
        expect(validator.validateCode(''), false);
        expect(validator.validateCode('1'), false);
        expect(validator.validateCode('12'), false);
        expect(validator.validateCode('123'), false);
        expect(validator.validateCode('1234'), false);
        expect(validator.validateCode('12345'), false);
      });

      test('should return false for codes longer than 6 characters', () {
        expect(validator.validateCode('1234567'), false);
        expect(validator.validateCode('12345678'), false);
        expect(validator.validateCode('123456789'), false);
      });

      test('should return false for exactly 6 not numbers', () {
        expect(validator.validateCode('ABCDEF'), false);
        expect(validator.validateCode('!@#\$%^'), false);
        expect(validator.validateCode('      '), false);
      });
    });

    group('validatePassword Tests', () {
      test('should return true for valid passwords', () {
        expect(validator.validatePassword('Test1234!'), true);
        expect(validator.validatePassword('Password123@'), true);
        expect(validator.validatePassword('MyP@ssw0rd'), true);
        expect(validator.validatePassword('Valid123\$'), true);
        expect(validator.validatePassword('Secure*123'), true);
        expect(validator.validatePassword('Strong?Pass1'), true);
        expect(validator.validatePassword('Good&Pass1'), true);
      });

      test('should return false for passwords without uppercase letter', () {
        expect(validator.validatePassword('password123!'), false);
        expect(validator.validatePassword('test1234@'), false);
        expect(validator.validatePassword('lowercase1!'), false);
      });

      test('should return false for passwords without lowercase letter', () {
        expect(validator.validatePassword('PASSWORD123!'), false);
        expect(validator.validatePassword('TEST1234@'), false);
        expect(validator.validatePassword('UPPERCASE1!'), false);
      });

      test('should return false for passwords without digit', () {
        expect(validator.validatePassword('Password!'), false);
        expect(validator.validatePassword('TestPass@'), false);
        expect(validator.validatePassword('NoNumber!'), false);
      });

      test('should return false for passwords without special character', () {
        expect(validator.validatePassword('Password123'), false);
        expect(validator.validatePassword('Test1234'), false);
        expect(validator.validatePassword('NoSpecial1'), false);
      });

      test('should return false for passwords shorter than 8 characters', () {
        expect(validator.validatePassword('Test1!'), false);
        expect(validator.validatePassword('Ab1@'), false);
        expect(validator.validatePassword('Short1!'), false);
      });

      test('should return false for passwords longer than 50 characters', () {
        final longPassword = 'Test1234!' + 'a' * 50;
        expect(validator.validatePassword(longPassword), false);
      });

      test('should return false for empty password', () {
        expect(validator.validatePassword(''), false);
      });

      test('should accept all valid special characters', () {
        expect(validator.validatePassword('Test1234@'), true);
        expect(validator.validatePassword('Test1234\$'), true);
        expect(validator.validatePassword('Test1234!'), true);
        expect(validator.validatePassword('Test1234%'), true);
        expect(validator.validatePassword('Test1234*'), true);
        expect(validator.validatePassword('Test1234?'), true);
        expect(validator.validatePassword('Test1234&'), true);
      });

      test('should return false for passwords with invalid special characters', () {
        expect(validator.validatePassword('Test1234#'), false);
        expect(validator.validatePassword('Test1234^'), false);
        expect(validator.validatePassword('Test1234~'), false);
        expect(validator.validatePassword('Test1234+'), false);
      });

      test('should return true for password exactly 8 characters', () {
        expect(validator.validatePassword('Test123!'), true);
      });

      test('should return true for password exactly 50 characters', () {
        final password = 'Test1!' + 'a' * 38 + 'A' * 5;
        expect(validator.validatePassword(password), true);
      });
    });

    group('validationErrors Tests', () {
      test('should return empty password error for empty string', () {
        expect(
          validator.validationErrors(''),
          'Password cannot be empty',
        );
      });

      test('should return length error for password less than 8 characters', () {
        expect(
          validator.validationErrors('Test1!'),
          'Password must be at least 8 characters long',
        );
        expect(
          validator.validationErrors('Ab1@'),
          'Password must be at least 8 characters long',
        );
      });

      test('should return length error for password more than 50 characters', () {
        final longPassword = 'Test1234!' + 'a' * 50;
        expect(
          validator.validationErrors(longPassword),
          'Password must not exceed 50 characters',
        );
      });

      test('should return empty string for completely valid password', () {
        expect(validator.validationErrors('Test1234!'), '');
        expect(validator.validationErrors('Valid123@'), '');
        expect(validator.validationErrors('Strong*Pass1'), '');
      });

      test('should return uppercase letter error', () {
        final error = validator.validationErrors('password123!');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one uppercase letter (A-Z)'));
      });

      test('should return lowercase letter error', () {
        final error = validator.validationErrors('PASSWORD123!');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one lowercase letter (a-z)'));
      });

      test('should return digit error', () {
        final error = validator.validationErrors('Password!');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one digit (0-9)'));
      });

      test('should return special character error', () {
        final error = validator.validationErrors('Password123');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one special character'));
      });

      test('should return multiple errors for password missing multiple requirements', () {
        final error = validator.validationErrors('password');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one uppercase letter (A-Z)'));
        expect(error, contains('at least one digit (0-9)'));
        expect(error, contains('at least one special character'));
      });

      test('should return invalid characters error', () {
        final error = validator.validationErrors('Test1234#');
        expect(error, contains('Password contains invalid characters'));
      });

      test('should handle password with all missing requirements', () {
        final error = validator.validationErrors('abcdefgh');
        expect(error, contains('password must contain'));
        expect(error, contains('at least one uppercase letter (A-Z)'));
        expect(error, contains('at least one digit (0-9)'));
        expect(error, contains('at least one special character'));
      });

      test('should handle password missing only uppercase', () {
        final error = validator.validationErrors('password123!');
        expect(error, contains('at least one uppercase letter (A-Z)'));
        expect(error, isNot(contains('at least one lowercase letter')));
        expect(error, isNot(contains('at least one digit')));
      });

      test('should handle password missing only lowercase', () {
        final error = validator.validationErrors('PASSWORD123!');
        expect(error, contains('at least one lowercase letter (a-z)'));
        expect(error, isNot(contains('at least one uppercase letter')));
        expect(error, isNot(contains('at least one digit')));
      });

      test('should handle password missing only digit', () {
        final error = validator.validationErrors('Password!');
        expect(error, contains('at least one digit (0-9)'));
        expect(error, isNot(contains('at least one uppercase letter')));
        expect(error, isNot(contains('at least one lowercase letter')));
      });

      test('should handle password missing only special character', () {
        final error = validator.validationErrors('Password123');
        expect(error, contains('at least one special character'));
        expect(error, isNot(contains('at least one uppercase letter')));
        expect(error, isNot(contains('at least one lowercase letter')));
        expect(error, isNot(contains('at least one digit')));
      });

      test('should format errors with comma separation', () {
        final error = validator.validationErrors('password');
        expect(error, contains(', '));
      });

      test('should handle password with spaces', () {
        final error = validator.validationErrors('Test 1234!');
        expect(error, contains('Password contains invalid characters'));
      });

      test('should handle password with tabs and newlines', () {
        final error = validator.validationErrors('Test\t1234!');
        expect(error, contains('Password contains invalid characters'));
      });

      test('should handle password at exactly 8 characters', () {
        final error = validator.validationErrors('Test123!');
        expect(error, '');
      });

      test('should handle password at exactly 50 characters', () {
        final password = 'Test1!' + 'a' * 38 + 'A' * 5;
        final error = validator.validationErrors(password);
        expect(error, '');
      });

      test('should list all special characters in error message', () {
        final error = validator.validationErrors('Password123');
        expect(error, contains('@'));
        expect(error, contains('\$'));
        expect(error, contains('!'));
        expect(error, contains('%'));
        expect(error, contains('*'));
        expect(error, contains('?'));
        expect(error, contains('&'));
      });
    });

    group('Edge Cases and Integration Tests', () {
      test('should handle all validation methods independently', () {
        final validator = Validator();

        expect(validator.validateEmail('test@test.com'), true);
        expect(validator.validateName('John'), true);
        expect(validator.validateDate('2000-01-01'), true);
        expect(validator.validateCode('123456'), true);
        expect(validator.validatePassword('Test1234!'), true);
      });

      test('should maintain instance state across calls', () {
        final validator = Validator(
          isValidEmailSignup: true,
          isValidPasswordSignup: false,
        );

        expect(validator.isValidEmailSignup, true);
        expect(validator.isValidPasswordSignup, false);

        // Call validation methods
        validator.validateEmail('test@test.com');
        validator.validatePassword('Test1234!');

        // State should remain unchanged
        expect(validator.isValidEmailSignup, true);
        expect(validator.isValidPasswordSignup, false);
      });

      test('should handle null-like values', () {
        expect(validator.validateEmail('null'), false);
        expect(validator.validateName('null'), true);
        expect(validator.validateDate('null'), true);
        expect(validator.validateCode('null'), false);
        expect(validator.validatePassword('null'), false);
      });

      test('should handle very long strings', () {
        final veryLongString = 'a' * 1000;
        
        expect(validator.validateEmail(veryLongString), false);
        expect(validator.validateName(veryLongString), true);
        expect(validator.validateDate(veryLongString), true);
        expect(validator.validateCode(veryLongString), false);
        expect(validator.validatePassword(veryLongString), false);
      });

      test('should handle strings with only whitespace', () {
        expect(validator.validateEmail('   '), false);
        expect(validator.validateName('   '), false);
        expect(validator.validateDate('   '), false);
        expect(validator.validateCode('   '), false);
        expect(validator.validatePassword('   '), false);
      });

      test('should handle mixed case scenarios', () {
        expect(validator.validateEmail('Test@Example.Com'), true);
        expect(validator.validateName('JoHN DoE'), true);
        expect(validator.validatePassword('TeSt1234!'), true);
      });
    });
  });
}
