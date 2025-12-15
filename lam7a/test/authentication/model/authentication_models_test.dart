import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';

void main() {
  group('AuthenticationUserDataModel', () {
    group('Constructor', () {
      test('should create instance with all parameters', () {
        final model = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Password123!',
          birthDate: '2000-01-15',
        );

        expect(model.name, equals('John Doe'));
        expect(model.email, equals('john@example.com'));
        expect(model.password, equals('Password123!'));
        expect(model.birthDate, equals('2000-01-15'));
      });

      test('should create instance with different names', () {
        final model = AuthenticationUserDataModel(
          name: 'Jane Smith',
          email: 'jane@example.com',
          password: 'SecurePass456!',
          birthDate: '1995-06-20',
        );

        expect(model.name, equals('Jane Smith'));
        expect(model.email, equals('jane@example.com'));
        expect(model.password, equals('SecurePass456!'));
        expect(model.birthDate, equals('1995-06-20'));
      });

      test('should create instance with special characters in name', () {
        final model = AuthenticationUserDataModel(
          name: "O'Brien-Smith",
          email: 'special@example.com',
          password: 'Pass123!',
          birthDate: '2000-01-01',
        );

        expect(model.name, equals("O'Brien-Smith"));
      });

      test('should create instance with plus sign in email', () {
        final model = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john+tag@example.com',
          password: 'Pass123!',
          birthDate: '2000-01-01',
        );

        expect(model.email, equals('john+tag@example.com'));
      });

      test('should create instance with numeric password', () {
        final model = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john@example.com',
          password: '123456789!@#',
          birthDate: '2000-01-01',
        );

        expect(model.password, equals('123456789!@#'));
      });

      test('should create instance with various date formats', () {
        final model1 = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Pass123!',
          birthDate: '2000-01-01',
        );

        final model2 = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Pass123!',
          birthDate: '1999-12-31',
        );

        expect(model1.birthDate, equals('2000-01-01'));
        expect(model2.birthDate, equals('1999-12-31'));
      });
    });

    group('fromJson factory', () {
      test('should create instance from valid JSON', () {
        final json = <String, dynamic>{
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'Password123!',
          'birthDate': '2000-01-15',
        };

        final model = AuthenticationUserDataModel.fromJson(json);

        expect(model.name, equals('John Doe'));
        expect(model.email, equals('john@example.com'));
        expect(model.password, equals('Password123!'));
        expect(model.birthDate, equals('2000-01-15'));
      });

      test('should create instance from JSON with different values', () {
        final json = <String, dynamic>{
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'password': 'SecurePass456!',
          'birthDate': '1995-06-20',
        };

        final model = AuthenticationUserDataModel.fromJson(json);

        expect(model.name, equals('Jane Smith'));
        expect(model.email, equals('jane@example.com'));
        expect(model.password, equals('SecurePass456!'));
        expect(model.birthDate, equals('1995-06-20'));
      });

      test('should handle JSON with special characters', () {
        final json = <String, dynamic>{
          'name': "O'Brien",
          'email': 'special+tag@example.com',
          'password': r'Pass@123!#$',
          'birthDate': '2000-01-01',
        };

        final model = AuthenticationUserDataModel.fromJson(json);

        expect(model.name, contains("O"));
        expect(model.email, contains("special+tag"));
      });

      test('should handle JSON with long strings', () {
        final json = <String, dynamic>{
          'name': 'John Alexander Montgomery Smith the Third',
          'email': 'verylongemailaddresswithnumberandstuff123@example.co.uk',
          'password': r'VeryLongPasswordWith123Symbols!@#$%^&*()',
          'birthDate': '2000-01-01',
        };

        final model = AuthenticationUserDataModel.fromJson(json);

        expect(model.name,
            equals('John Alexander Montgomery Smith the Third'));
        expect(model.email,
            equals('verylongemailaddresswithnumberandstuff123@example.co.uk'));
        expect(model.password,
            equals(r'VeryLongPasswordWith123Symbols!@#$%^&*()'));
      });
    });

    group('toJson method', () {
      test('should convert instance to JSON', () {
        final model = AuthenticationUserDataModel(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Password123!',
          birthDate: '2000-01-15',
        );

        final json = model.toJson();

        expect(json['name'], equals('John Doe'));
        expect(json['email'], equals('john@example.com'));
        expect(json['password'], equals('Password123!'));
        expect(json['birthDate'], equals('2000-01-15'));
      });

      test('should convert to JSON and back to model', () {
        final original = AuthenticationUserDataModel(
          name: 'Jane Smith',
          email: 'jane@example.com',
          password: 'SecurePass456!',
          birthDate: '1995-06-20',
        );

        final json = original.toJson();
        final model = AuthenticationUserDataModel.fromJson(json);

        expect(model.name, equals(original.name));
        expect(model.email, equals(original.email));
        expect(model.password, equals(original.password));
        expect(model.birthDate, equals(original.birthDate));
      });
    });
  });

  group('AuthenticationUserCredentialsModel', () {
    group('Constructor', () {
      test('should create instance with all parameters', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'john@example.com',
          password: 'Password123!',
        );

        expect(model.email, equals('john@example.com'));
        expect(model.password, equals('Password123!'));
      });

      test('should create instance with different credentials', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'jane@example.com',
          password: 'SecurePass456!',
        );

        expect(model.email, equals('jane@example.com'));
        expect(model.password, equals('SecurePass456!'));
      });

      test('should create instance with special characters in email', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'john+tag@example.co.uk',
          password: 'Pass123!',
        );

        expect(model.email, equals('john+tag@example.co.uk'));
      });

      test('should create instance with complex password', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'john@example.com',
          password: r'P@ssw0rd!#$%^&*()',
        );

        expect(model.password, equals(r'P@ssw0rd!#$%^&*()'));
      });

      test('should create instance with very long email', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'verylongemailwithlotsofcharacters123@subdomain.example.co.uk',
          password: 'Pass123!',
        );

        expect(model.email,
            equals('verylongemailwithlotsofcharacters123@subdomain.example.co.uk'));
      });

      test('should create instance with minimum password length', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'john@example.com',
          password: 'P1!',
        );

        expect(model.password, equals('P1!'));
      });
    });

    group('fromJson factory', () {
      test('should create instance from valid JSON', () {
        final json = <String, dynamic>{
          'email': 'john@example.com',
          'password': 'Password123!',
        };

        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals('john@example.com'));
        expect(model.password, equals('Password123!'));
      });

      test('should create instance from JSON with different values', () {
        final json = <String, dynamic>{
          'email': 'test@domain.org',
          'password': 'TestPass789!',
        };

        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals('test@domain.org'));
        expect(model.password, equals('TestPass789!'));
      });

      test('should handle JSON with special email characters', () {
        final json = <String, dynamic>{
          'email': 'user+special@example.com',
          'password': r'Pass123!@#',
        };

        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals('user+special@example.com'));
      });

      test('should handle JSON with numeric email prefix', () {
        final json = <String, dynamic>{
          'email': '123user@example.com',
          'password': 'Pass123!',
        };

        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals('123user@example.com'));
      });

      test('should handle JSON with hyphenated email', () {
        final json = <String, dynamic>{
          'email': 'user-name@example.com',
          'password': 'Pass123!',
        };

        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals('user-name@example.com'));
      });
    });

    group('toJson method', () {
      test('should convert instance to JSON', () {
        final model = AuthenticationUserCredentialsModel(
          email: 'john@example.com',
          password: 'Password123!',
        );

        final json = model.toJson();

        expect(json['email'], equals('john@example.com'));
        expect(json['password'], equals('Password123!'));
      });

      test('should convert to JSON and back to model', () {
        final original = AuthenticationUserCredentialsModel(
          email: 'jane@example.com',
          password: 'SecurePass456!',
        );

        final json = original.toJson();
        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals(original.email));
        expect(model.password, equals(original.password));
      });

      test('should convert JSON with special characters to model', () {
        final original = AuthenticationUserCredentialsModel(
          email: 'user+tag@example.co.uk',
          password: r'P@ss123!#$',
        );

        final json = original.toJson();
        final model = AuthenticationUserCredentialsModel.fromJson(json);

        expect(model.email, equals(original.email));
        expect(model.password, equals(original.password));
      });
    });
  });

  group('Cross-Model Tests', () {
    test(
        'AuthenticationUserDataModel should have more fields than AuthenticationUserCredentialsModel',
        () {
      final dataModel = AuthenticationUserDataModel(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'Password123!',
        birthDate: '2000-01-15',
      );

      final credentialsModel = AuthenticationUserCredentialsModel(
        email: 'john@example.com',
        password: 'Password123!',
      );

      // Data model has name and birthDate in addition to credentials
      expect(dataModel.name, equals('John Doe'));
      expect(dataModel.birthDate, equals('2000-01-15'));

      // Credentials model only has email and password
      expect(credentialsModel.email, equals('john@example.com'));
      expect(credentialsModel.password, equals('Password123!'));
    });

    test(
        'AuthenticationUserDataModel email should match credentials email format',
        () {
      final email = 'john@example.com';
      final dataModel = AuthenticationUserDataModel(
        name: 'John Doe',
        email: email,
        password: 'Password123!',
        birthDate: '2000-01-15',
      );

      final credentialsModel = AuthenticationUserCredentialsModel(
        email: email,
        password: 'Password123!',
      );

      expect(dataModel.email, equals(credentialsModel.email));
      expect(dataModel.password, equals(credentialsModel.password));
    });
  });
}
