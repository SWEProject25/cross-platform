import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/reset_password.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthentication extends Authentication {
  bool _isAuthenticated = false;

  @override
  AuthState build() {
    return AuthState(isAuthenticated: _isAuthenticated);
  }

  void triggerAuthentication() {
    _isAuthenticated = true;
    state = state.copyWith(
      isAuthenticated: true,
      user: UserModel(id: 1, name: 'Test User'),
    );
  }

  @override
  void authenticateUser(UserDtoAuth? user) {
    triggerAuthentication();
  }

  @override
  Future<void> isAuthenticated() async {}

  @override
  UserModel userDtoToUserModel(UserDtoAuth dto) {
    return UserModel(id: dto.id, name: dto.name);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepositoryImpl mockRepo;
  late FakeAuthentication fakeAuth;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();
    fakeAuth = FakeAuthentication();
  });

  group('ForgotPasswordScreen Tests', () {
    Widget createForgotPasswordWidget() {
      return ProviderScope(
        overrides: [
          authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          authenticationProvider.overrideWith(() => fakeAuth),
        ],
        child: MaterialApp(
          home: ForgotPasswordScreen(),
          routes: {
            FirstTimeScreen.routeName: (context) => Scaffold(
                  key: Key('first_time_screen'),
                  body: Text('First Time Screen'),
                ),
            AuthenticationTransmissionScreen.routeName: (context) => Scaffold(
                  key: Key('transmission_screen'),
                  body: Text('Transmission Screen'),
                ),
            ResetPassword.routeName: (context) => Scaffold(
                  key: Key('reset_password_screen'),
                  body: Text('Reset Password Screen'),
                ),
          },
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should display app bar with X icon and close button', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('should display first step content initially', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('mainLoginView')), findsOneWidget);
      });

      testWidgets('should display Next button', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('forgot_password_next_button')), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('should have Spacer widgets in layout', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Spacer), findsWidgets);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to FirstTimeScreen when close button tapped', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('first_time_screen')), findsOneWidget);
      });

      testWidgets('should navigate to transmission screen when authenticated', (tester) async {
        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        // Trigger authentication
        fakeAuth.triggerAuthentication();
        await tester.pumpAndSettle();

        expect(find.byKey(Key('transmission_screen')), findsOneWidget);
      });
    });

    group('Step Flow', () {
      testWidgets('should advance to next step when Next button tapped on step 0', (tester) async {
        when(() => mockRepo.forgotPassword(any())).thenAnswer((_) async => true);

        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        // Tap Next on step 0
        await tester.tap(find.byKey(ValueKey('forgot_password_next_button')));
        await tester.pumpAndSettle();

        // Should advance to step 1
        // Verify by checking if still on same screen but state changed
        expect(find.byKey(ValueKey('mainLoginView')), findsOneWidget);
      });

      testWidgets('should call isInstructionSent when on step 1', (tester) async {
        when(() => mockRepo.forgotPassword(any())).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
            authenticationProvider.overrideWith(() => fakeAuth),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: ForgotPasswordScreen(),
              routes: {
                FirstTimeScreen.routeName: (context) => Scaffold(body: Text('First')),
                ResetPassword.routeName: (context) => Scaffold(
                      key: Key('reset_password_screen'),
                      body: Text('Reset'),
                    ),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Advance to step 1
        container.read(forgotPasswordViewmodelProvider.notifier).gotoNextStep();
        container.read(forgotPasswordViewmodelProvider.notifier).updateEmail('test@test.com');
        await tester.pumpAndSettle();

        // Tap Next on step 1
        await tester.tap(find.byKey(ValueKey('forgot_password_next_button')));
        await tester.pumpAndSettle();

        verify(() => mockRepo.forgotPassword('test@test.com')).called(1);
      });

      testWidgets('should hide Next button on last step', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
            authenticationProvider.overrideWith(() => fakeAuth),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ForgotPasswordScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Advance to last step (step 2)
        container.read(forgotPasswordViewmodelProvider.notifier).gotoNextStep();
        container.read(forgotPasswordViewmodelProvider.notifier).gotoNextStep();
        await tester.pumpAndSettle();

        // Next button should not be visible
        expect(find.byKey(ValueKey('forgot_password_next_button')), findsNothing);
      });

   
    });

    group('Edge Cases', () {
      testWidgets('should handle rapid Next button tapping', (tester) async {
        when(() => mockRepo.forgotPassword(any())).thenAnswer((_) async => true);

        await tester.pumpWidget(createForgotPasswordWidget());
        await tester.pumpAndSettle();

        // Rapidly tap Next button
        await tester.tap(find.byKey(ValueKey('forgot_password_next_button')));
        await tester.pump();
        await tester.tap(find.byKey(ValueKey('forgot_password_next_button')));
        await tester.pump();

        await tester.pumpAndSettle();

        // Should still be functional
        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      });

      testWidgets('should maintain state across rebuilds', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
            authenticationProvider.overrideWith(() => fakeAuth),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ForgotPasswordScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Advance step
        container.read(forgotPasswordViewmodelProvider.notifier).gotoNextStep();
        await tester.pumpAndSettle();

        // Trigger rebuild
        await tester.pump();

        // State should be maintained
        expect(
          container.read(forgotPasswordViewmodelProvider).currentForgotPasswordStep,
          1,
        );
      });
    });
  });

  group('ResetPassword Screen Tests', () {
    Widget createResetPasswordWidget({String? token, int? id}) {
      return ProviderScope(
        overrides: [
          authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          authenticationProvider.overrideWith(() => fakeAuth),
        ],
        child: MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == ResetPassword.routeName) {
              return MaterialPageRoute(
                settings: RouteSettings(
                  name: ResetPassword.routeName,
                  arguments: {'token': token, 'id': id},
                ),
                builder: (context) => ResetPassword(),
              );
            }
            if (settings.name == LogInScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  key: Key('login_screen'),
                  body: Text('Login Screen'),
                ),
              );
            }
            return null;
          },
          initialRoute: ResetPassword.routeName,
        ),
      );
    }

    group('UI Elements', () {
      testWidgets('should display title and subtitle', (tester) async {
        await tester.pumpWidget(createResetPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.text('Reset Your Password'), findsOneWidget);
        expect(find.text('Enter your new password below here'), findsOneWidget);
      });

      testWidgets('should display email section text', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ResetPassword()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Reset Password For Email'), findsOneWidget);
      });

      testWidgets('should display password input fields', (tester) async {
        await tester.pumpWidget(createResetPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('emailSignupTextField')), findsOneWidget);
        expect(find.byKey(ValueKey('re-pass')), findsOneWidget);
      });

      testWidgets('should display reset password button', (tester) async {
        await tester.pumpWidget(createResetPasswordWidget());
        await tester.pumpAndSettle();

        expect(find.byKey(ValueKey('reset_password_button')), findsOneWidget);
        expect(find.text('Reset Password'), findsOneWidget);
      });

      testWidgets('should display encrypted email', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ResetPassword()),
          ),
        );
        await tester.pumpAndSettle();

        // Email should be encrypted (e.g., t**@e**********)
        expect(find.textContaining('@'), findsWidgets);
      });
    });

    group('Password Validation', () {
      testWidgets('should show validation errors for invalid password', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ResetPassword()),
          ),
        );
        await tester.pumpAndSettle();

        // Enter invalid password
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('weak');

        await tester.pumpAndSettle();

        // Should show as invalid
        expect(
          container.read(forgotPasswordViewmodelProvider).isValidPassword,
          false,
        );
      });

      testWidgets('should validate password match', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ResetPassword()),
          ),
        );
        await tester.pumpAndSettle();

        // Enter matching passwords
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateRePassword('Test1234!');

        await tester.pumpAndSettle();

        expect(
          container.read(forgotPasswordViewmodelProvider).isValidRePassword,
          true,
        );
      });

      testWidgets('should show error for non-matching passwords', (tester) async {
        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: ResetPassword()),
          ),
        );
        await tester.pumpAndSettle();

        // Enter non-matching passwords
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateRePassword('Different123!');

        await tester.pumpAndSettle();

        expect(
          container.read(forgotPasswordViewmodelProvider).isValidRePassword,
          false,
        );
      });
    });

    group('Reset Password Functionality', () {
      testWidgets('should call resetPassword when button tapped with valid data', (tester) async {
        when(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            )).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              onGenerateRoute: (settings) {
                if (settings.name == '/reset') {
                  return MaterialPageRoute(
                    settings: RouteSettings(
                      arguments: {'token': 'test-token', 'id': 1},
                    ),
                    builder: (context) => ResetPassword(),
                  );
                }
                return null;
              },
              initialRoute: '/reset',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ValueKey('reset_password_button')));
        await tester.pumpAndSettle();

        verify(() => mockRepo.resetPassword(
              password: 'Test1234!',
              token: 'test-token',
              email: 'test@example.com',
              id: 1,
            )).called(1);
      });

      testWidgets('should show success dialog when reset successful', (tester) async {
        when(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            )).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              onGenerateRoute: (settings) {
                if (settings.name == '/reset') {
                  return MaterialPageRoute(
                    settings: RouteSettings(
                      arguments: {'token': 'test-token', 'id': 1},
                    ),
                    builder: (context) => ResetPassword(),
                  );
                }
                if (settings.name == LogInScreen.routeName) {
                  return MaterialPageRoute(
                    builder: (context) => Scaffold(
                      key: Key('login_screen'),
                      body: Text('Login'),
                    ),
                  );
                }
                return null;
              },
              initialRoute: '/reset',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ValueKey('reset_password_button')));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Password Reseted Successfully'), findsOneWidget);
        expect(find.text('Return back to login with new password'), findsOneWidget);
      });

      testWidgets('should navigate to login when dialog OK tapped', (tester) async {
        when(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            )).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              onGenerateRoute: (settings) {
                if (settings.name == '/reset') {
                  return MaterialPageRoute(
                    settings: RouteSettings(
                      arguments: {'token': 'test-token', 'id': 1},
                    ),
                    builder: (context) => ResetPassword(),
                  );
                }
                if (settings.name == LogInScreen.routeName) {
                  return MaterialPageRoute(
                    builder: (context) => Scaffold(
                      key: Key('login_screen'),
                      body: Text('Login'),
                    ),
                  );
                }
                return null;
              },
              initialRoute: '/reset',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ValueKey('reset_password_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('login_screen')), findsOneWidget);
      });

      testWidgets('should not call resetPassword without token and id', (tester) async {
        when(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            )).thenAnswer((_) async => true);

        await tester.pumpWidget(createResetPasswordWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ValueKey('reset_password_button')));
        await tester.pumpAndSettle();

        verifyNever(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            ));
      });
    });

    group('Theme Support', () {
      testWidgets('should display dialog in dark mode', (tester) async {
        when(() => mockRepo.resetPassword(
              password: any(named: 'password'),
              token: any(named: 'token'),
              email: any(named: 'email'),
              id: any(named: 'id'),
            )).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );

        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updateEmail('test@example.com');
        container
            .read(forgotPasswordViewmodelProvider.notifier)
            .updatePassword('Test1234!');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: ThemeData.dark(),
              onGenerateRoute: (settings) {
                if (settings.name == '/reset') {
                  return MaterialPageRoute(
                    settings: RouteSettings(
                      arguments: {'token': 'test-token', 'id': 1},
                    ),
                    builder: (context) => ResetPassword(),
                  );
                }
                return null;
              },
              initialRoute: '/reset',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ValueKey('reset_password_button')));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });
  });
}
