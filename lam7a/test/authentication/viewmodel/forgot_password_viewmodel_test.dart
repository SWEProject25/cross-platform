import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/forgot_password_state.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepositoryImpl mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();

    container = ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  ForgotPasswordViewmodel getNotifier() {
    return container.read(forgotPasswordViewmodelProvider.notifier);
  }

  ForgotPasswordState getState() {
    return container.read(forgotPasswordViewmodelProvider);
  }

  group('ForgotPasswordViewmodel - Initial State', () {
    test('should initialize with default state', () {
      final state = getState();

      expect(state.currentForgotPasswordStep, 0);
      expect(state.email, '');
      expect(state.password, '');
      expect(state.reTypePassword, '');
      expect(state.isValidEmail, false);
      expect(state.isValidPassword, false);
      expect(state.isValidRePassword, false);
    });
  });

  group('ForgotPasswordViewmodel - gotoNextStep', () {
    test('should increment currentForgotPasswordStep by 1', () {
      final notifier = getNotifier();
      final initialStep = getState().currentForgotPasswordStep;

      notifier.gotoNextStep();

      expect(getState().currentForgotPasswordStep, initialStep + 1);
    });

    test('should increment step multiple times', () {
      final notifier = getNotifier();

      notifier.gotoNextStep();
      expect(getState().currentForgotPasswordStep, 1);

      notifier.gotoNextStep();
      expect(getState().currentForgotPasswordStep, 2);

      notifier.gotoNextStep();
      expect(getState().currentForgotPasswordStep, 3);
    });
  });

  group('ForgotPasswordViewmodel - updateEmail', () {
    test('should update email with valid email address', () {
      final notifier = getNotifier();

      notifier.updateEmail('test@example.com');

      final state = getState();
      expect(state.email, 'test@example.com');
      expect(state.isValidEmail, true);
    });

    test('should update email with invalid email address', () {
      final notifier = getNotifier();

      notifier.updateEmail('invalid-email');

      final state = getState();
      expect(state.email, 'invalid-email');
      expect(state.isValidEmail, false);
    });

    test('should update email with empty string', () {
      final notifier = getNotifier();

      notifier.updateEmail('');

      final state = getState();
      expect(state.email, '');
      expect(state.isValidEmail, false);
    });

    test('should update isValidEmail to false for email without @', () {
      final notifier = getNotifier();

      notifier.updateEmail('testexample.com');

      final state = getState();
      expect(state.email, 'testexample.com');
      expect(state.isValidEmail, false);
    });
  });

  group('ForgotPasswordViewmodel - updatePassword', () {
    test('should update password with valid password', () {
      final notifier = getNotifier();

      notifier.updatePassword('Test1234!');

      final state = getState();
      expect(state.password, 'Test1234!');
      expect(state.isValidPassword, true);
    });

    test('should update password with invalid password', () {
      final notifier = getNotifier();

      notifier.updatePassword('weak');

      final state = getState();
      expect(state.password, 'weak');
      expect(state.isValidPassword, false);
    });

    test('should set isValidRePassword to false when passwords do not match', () {
      final notifier = getNotifier();

      // Set reTypePassword first
      notifier.updateRePassword('Test1234!');
      // Then update password with different value
      notifier.updatePassword('Different123!');

      final state = getState();
      expect(state.password, 'Different123!');
      expect(state.isValidRePassword, false);
    });

    test('should set isValidRePassword to true when passwords match', () {
      final notifier = getNotifier();

      notifier.updatePassword('Test1234!');
      notifier.updateRePassword('Test1234!');

      final state = getState();
      expect(state.password, 'Test1234!');
      expect(state.isValidRePassword, true);
    });
  });

  group('ForgotPasswordViewmodel - updateRePassword', () {
    test('should update reTypePassword and set isValidRePassword to true when matching', () {
      final notifier = getNotifier();

      notifier.updatePassword('Test1234!');
      notifier.updateRePassword('Test1234!');

      final state = getState();
      expect(state.reTypePassword, 'Test1234!');
      expect(state.isValidRePassword, true);
    });

    test('should update reTypePassword and set isValidRePassword to false when not matching', () {
      final notifier = getNotifier();

      notifier.updatePassword('Test1234!');
      notifier.updateRePassword('Different123!');

      final state = getState();
      expect(state.reTypePassword, 'Different123!');
      expect(state.isValidRePassword, false);
    });

    test('should handle empty reTypePassword', () {
      final notifier = getNotifier();

      notifier.updatePassword('Test1234!');
      notifier.updateRePassword('');

      final state = getState();
      expect(state.reTypePassword, '');
      expect(state.isValidRePassword, false);
    });
  });

  group('ForgotPasswordViewmodel - EncryptEmail', () {
    test('should return empty string when email is empty', () {
      final notifier = getNotifier();

      final result = notifier.EncryptEmail('');

      expect(result, '');
    });

    test('should encrypt email correctly with standard format', () {
      final notifier = getNotifier();

      final result = notifier.EncryptEmail('test@example.com');

      expect(result, 't**@e**********');
    });

    test('should encrypt short email correctly', () {
      final notifier = getNotifier();

      final result = notifier.EncryptEmail('a@b.co');

      expect(result, 'a@b***');
    });

    test('should encrypt email with long local part', () {
      final notifier = getNotifier();

      final result = notifier.EncryptEmail('verylongemail@domain.com');

      expect(result, 'v***********@d*********');
    });

    test('should encrypt email with subdomain', () {
      final notifier = getNotifier();

      final result = notifier.EncryptEmail('user@mail.example.com');

      expect(result, 'u**@m***************');
    });
  });

  group('ForgotPasswordViewmodel - isInstructionSent', () {
    test('should call forgotPassword and go to next step when successful', () async {
      final notifier = getNotifier();
      const email = 'test@example.com';

      when(() => mockRepo.forgotPassword(email)).thenAnswer((_) async => true);

      await notifier.isInstructionSent(email);

      verify(() => mockRepo.forgotPassword(email)).called(1);
      expect(getState().currentForgotPasswordStep, 1);
    });

    test('should call forgotPassword but not advance step when unsuccessful', () async {
      final notifier = getNotifier();
      const email = 'test@example.com';

      when(() => mockRepo.forgotPassword(email)).thenAnswer((_) async => false);

      await notifier.isInstructionSent(email);

      verify(() => mockRepo.forgotPassword(email)).called(1);
      expect(getState().currentForgotPasswordStep, 0);
    });

    test('should handle different email addresses', () async {
      final notifier = getNotifier();

      when(() => mockRepo.forgotPassword(any())).thenAnswer((_) async => true);

      await notifier.isInstructionSent('user1@test.com');
      verify(() => mockRepo.forgotPassword('user1@test.com')).called(1);

      await notifier.isInstructionSent('user2@test.com');
      verify(() => mockRepo.forgotPassword('user2@test.com')).called(1);
    });
  });

  group('ForgotPasswordViewmodel - resetPassword', () {
    test('should call resetPassword and return true when successful', () async {
      final notifier = getNotifier();
      const token = 'reset-token-123';
      const id = 1;

      // Set up password
      notifier.updatePassword('NewPassword123!');
      notifier.updateEmail('test@example.com');

      when(
        () => mockRepo.resetPassword(
          password: any(named: 'password'),
          token: any(named: 'token'),
          email: any(named: 'email'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => true);

      final result = await notifier.resetPassword(token, id);

      expect(result, true);
      verify(
        () => mockRepo.resetPassword(
          password: 'NewPassword123!',
          token: token,
          email: 'test@example.com',
          id: id,
        ),
      ).called(1);
    });

    test('should call resetPassword and return false when unsuccessful', () async {
      final notifier = getNotifier();
      const token = 'invalid-token';
      const id = 2;

      notifier.updatePassword('Password123!');
      notifier.updateEmail('user@example.com');

      when(
        () => mockRepo.resetPassword(
          password: any(named: 'password'),
          token: any(named: 'token'),
          email: any(named: 'email'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => false);

      final result = await notifier.resetPassword(token, id);

      expect(result, false);
      verify(
        () => mockRepo.resetPassword(
          password: 'Password123!',
          token: token,
          email: 'user@example.com',
          id: id,
        ),
      ).called(1);
    });

    test('should use current state password in resetPassword call', () async {
      final notifier = getNotifier();
      const token = 'token-abc';
      const id = 5;

      notifier.updateEmail('test@test.com');
      notifier.updatePassword('MySecretPass1!');

      when(
        () => mockRepo.resetPassword(
          password: any(named: 'password'),
          token: any(named: 'token'),
          email: any(named: 'email'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => true);

      await notifier.resetPassword(token, id);

      verify(
        () => mockRepo.resetPassword(
          password: 'MySecretPass1!',
          token: token,
          email: 'test@test.com',
          id: id,
        ),
      ).called(1);
    });

    test('should handle different user IDs', () async {
      final notifier = getNotifier();

      notifier.updateEmail('email@test.com');
      notifier.updatePassword('Pass123!');

      when(
        () => mockRepo.resetPassword(
          password: any(named: 'password'),
          token: any(named: 'token'),
          email: any(named: 'email'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => true);

      await notifier.resetPassword('token', 10);
      verify(() => mockRepo.resetPassword(
            password: 'Pass123!',
            token: 'token',
            email: 'email@test.com',
            id: 10,
          )).called(1);

      await notifier.resetPassword('token2', 20);
      verify(() => mockRepo.resetPassword(
            password: 'Pass123!',
            token: 'token2',
            email: 'email@test.com',
            id: 20,
          )).called(1);
    });
  });

  group('ForgotPasswordViewmodel - Integration Tests', () {
    test('should handle complete password reset flow', () async {
      final notifier = getNotifier();

      // Step 1: Update email
      notifier.updateEmail('user@example.com');
      expect(getState().email, 'user@example.com');
      expect(getState().isValidEmail, true);

      // Step 2: Send instruction
      when(() => mockRepo.forgotPassword('user@example.com'))
          .thenAnswer((_) async => true);

      await notifier.isInstructionSent('user@example.com');
      expect(getState().currentForgotPasswordStep, 1);

      // Step 3: Update password
      notifier.updatePassword('NewPassword123!');
      notifier.updateRePassword('NewPassword123!');
      expect(getState().isValidPassword, true);
      expect(getState().isValidRePassword, true);

      // Step 4: Reset password
      when(
        () => mockRepo.resetPassword(
          password: any(named: 'password'),
          token: any(named: 'token'),
          email: any(named: 'email'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => true);

      final result = await notifier.resetPassword('token', 1);
      expect(result, true);
    });

    test('should maintain state across multiple operations', () {
      final notifier = getNotifier();

      notifier.updateEmail('test@test.com');
      notifier.updatePassword('Pass123!');
      notifier.gotoNextStep();

      final state = getState();
      expect(state.email, 'test@test.com');
      expect(state.password, 'Pass123!');
      expect(state.currentForgotPasswordStep, 1);
    });
  });
}
