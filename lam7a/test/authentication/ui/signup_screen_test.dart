import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_otp_code_Step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthenticationUserDataModel extends Fake
    implements AuthenticationUserDataModel {}

class FakeAuthentication extends Authentication {
  @override
  AuthState build() => AuthState();

  @override
  void authenticateUser(UserModel? user) {
    state = state.copyWith(token: null, isAuthenticated: true, user: user);
  }
}

void main() {
  late MockAuthenticationRepositoryImpl mockRepo;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();
    registerFallbackValue(FakeAuthenticationUserDataModel());
    registerFallbackValue(UserModel());
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
        authenticationProvider.overrideWith(() => FakeAuthentication()),
      ],
    );
  }

  AuthenticationViewmodel getNotifier(ProviderContainer container) {
    final notifier = container.read(authenticationViewmodelProvider.notifier);
    container.read(authenticationViewmodelProvider);
    return notifier;
  }

  group('Signup Screen User Data Step Tests', () {
    testWidgets(
      'should display name, email, and date fields on userData step',
      (tester) async {
        final container = createContainer();
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child),
          );
        }

        final notifier = getNotifier(container);
        notifier.state = const AuthenticationState.signup(currentSignupStep: 0);
        final testWidget = SignUpFlow();

        await tester.pumpWidget(createWidgetUnderTest(testWidget));

        expect(find.byKey(const Key('nameTextField')), findsOneWidget);
        expect(find.byKey(const Key('emailSignupTextField')), findsOneWidget);
        expect(find.byKey(const Key('datePickerTextField')), findsOneWidget);
        expect(find.byKey(const Key('nextSignupStepButton')), findsOneWidget);

        container.dispose();
      },
    );
    testWidgets('should display otpCode field, ajd the dresend otp text', (
      tester,
    ) async {
      final container = createContainer();
      final notifier = getNotifier(container);
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidCode: true,
        isValidDate: true,
        isValidEmail: true,
        isLoadingSignup: false,
      );
      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('otpCodeTextField')), findsOneWidget);
      expect(find.byKey(const Key('resendOtpText')), findsOneWidget);
      expect(find.byKey(const Key('nextSignupStepButton')), findsOneWidget);

      container.dispose();
    });
    testWidgets('should display PasswordField field', (tester) async {
      final container = createContainer();
      final notifier = getNotifier(container);
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidCode: true,
        isValidDate: true,
        isValidEmail: true,
        isLoadingSignup: false,
      );
      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('passwordSignupTextField')), findsOneWidget);
      expect(find.byKey(const Key('nextSignupStepButton')), findsOneWidget);

      container.dispose();
    });
    testWidgets('test init state for otpCode', (tester) async {
      final container = createContainer();
      final notifier = getNotifier(container);
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidDate: true,
        isValidEmail: true,
        isLoadingSignup: false,
      );
      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey("resendOtpText")), findsOneWidget);
      final state = tester.state(find.byType(VerificationCode)) as dynamic;
      expect(state.enableResend, false);
      expect(state.secondsRemaining, 60);

      await tester.pump(const Duration(seconds: 1));
      expect(state.secondsRemaining, 59);

      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
      container.dispose();
      container.dispose();
    });
    testWidgets('test show toast when resend OTP tapped before timer expires', (
      tester,
    ) async {
      final container = createContainer();
      final notifier = getNotifier(container);

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidDate: true,
        isValidEmail: true,
        isLoadingSignup: false,
      );
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(VerificationCode)) as dynamic;
      expect(state.enableResend, false);
      expect(state.secondsRemaining, 60);

      await tester.tap(find.byKey(const ValueKey("resendOtpInkWell")));
      await tester.pumpAndSettle();

      container.dispose();
    });

    testWidgets('test call resendOTP when timer expires and button is tapped', (
      tester,
    ) async {
      final container = createContainer();
      final notifier = getNotifier(container);

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidDate: true,
        isValidEmail: true,
        isLoadingSignup: false,
      );
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 61));

      final state = tester.state(find.byType(VerificationCode)) as dynamic;
      expect(state.enableResend, true);
      expect(state.secondsRemaining, 0);

      await tester.tap(find.byKey(const ValueKey("resendOtpInkWell")));
      await tester.pumpAndSettle();

      expect(state.secondsRemaining, 60);
      expect(state.enableResend, false);

      container.dispose();
    });
    testWidgets('should go back to the firet screen when tap back', (
      tester,
    ) async {
      final container = createContainer();
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: child,
            routes: {FirstTimeScreen.routeName: (context) => FirstTimeScreen()},
          ),
        );
      }

      final notifier = getNotifier(container);
      notifier.state = const AuthenticationState.signup(currentSignupStep: 0);
      final testWidget = SignUpFlow();
      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('firstScreen')), findsOneWidget);

      container.dispose();
    });
    testWidgets(
      'should go back to the last sign up step when tap back and there are some steps',
      (tester) async {
        final container = createContainer();
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: child,
              routes: {
                FirstTimeScreen.routeName: (context) => FirstTimeScreen(),
              },
            ),
          );
        }

        final notifier = getNotifier(container);
        notifier.state = const AuthenticationState.signup(currentSignupStep: 2);
        final testWidget = SignUpFlow();
        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();
        final backButton = find.byIcon(Icons.arrow_back);
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('otpCodeTextField')), findsOneWidget);
        expect(
          container.read(authenticationViewmodelProvider).currentSignupStep,
          1,
        );
        container.dispose();
      },
    );
    testWidgets('test loading indicator appears', (tester) async {
      final container = createContainer();
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final notifier = getNotifier(container);
      notifier.state = const AuthenticationState.signup(isLoadingSignup: true);
      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));

      expect(find.byKey(const ValueKey('loading')), findsOneWidget);

      container.dispose();
    });
    testWidgets(
      'should call checkValidEmail when next button pressed on userData step with valid data and if true go to next step',
      (tester) async {
        final container = createContainer();
        final notifier = container.read(
          authenticationViewmodelProvider.notifier,
        );
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child),
          );
        }

        final testWidget = SignUpFlow();

        when(() => mockRepo.checkEmail(any())).thenAnswer((_) async => true);
        when(
          () => mockRepo.verificationOTP(any()),
        ).thenAnswer((_) async => true);

        notifier.state = const AuthenticationState.signup(
          currentSignupStep: 0,
          name: 'John Doe',
          email: 'john@example.com',
          date: '2000-01-01',
          isValidName: true,
          isValidEmail: true,
          isValidDate: true,
        );

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();

        final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        verify(() => mockRepo.checkEmail('john@example.com')).called(1);
        verify(() => mockRepo.verificationOTP('john@example.com')).called(1);

        expect(
          container.read(authenticationViewmodelProvider).currentSignupStep,
          1,
        );
        container.dispose();
      },
    );
    testWidgets(
      'should call verifyOtp when next button pressed on VerificationOtp step with valid data and if true go to next step',
      (tester) async {
        final container = createContainer();
        final notifier = container.read(
          authenticationViewmodelProvider.notifier,
        );
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child),
          );
        }

        final testWidget = SignUpFlow();

        when(
          () => mockRepo.verifyOTP(any(), any()),
        ).thenAnswer((_) async => true);

        notifier.state = const AuthenticationState.signup(
          currentSignupStep: 1,
          name: 'John Doe',
          email: 'john@example.com',
          date: '2000-01-01',
          code: "123456",
          isValidName: true,
          isValidEmail: true,
          isValidDate: true,
          isValidCode: true,
        );

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();

        final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        verify(
          () => mockRepo.verifyOTP('john@example.com', "123456"),
        ).called(1);

        expect(
          container.read(authenticationViewmodelProvider).currentSignupStep,
          2,
        );

        container.dispose();
      },
    );
    testWidgets(
      'should call verifyOtp when next button pressed on VerificationOtp step with Not Valid data and if true go to next step',
      (tester) async {
        final container = createContainer();
        final notifier = container.read(
          authenticationViewmodelProvider.notifier,
        );
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child),
          );
        }

        final testWidget = SignUpFlow();

        when(
          () => mockRepo.verifyOTP(any(), any()),
        ).thenAnswer((_) async => false);

        notifier.state = const AuthenticationState.signup(
          currentSignupStep: 1,
          name: 'John Doe',
          email: 'john@example.com',
          date: '2000-01-01',
          code: "123456",
          isValidName: true,
          isValidEmail: true,
          isValidDate: true,
          isValidCode: true,
        );

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();

        final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        verify(
          () => mockRepo.verifyOTP('john@example.com', "123456"),
        ).called(1);

        expect(
          container.read(authenticationViewmodelProvider).currentSignupStep,
          1,
        );

        container.dispose();
      },
    );
    testWidgets(
      'should call newUser when reaches the last signup step and has valid password',
      (tester) async {
        final container = createContainer();
        final notifier = container.read(
          authenticationViewmodelProvider.notifier,
        );
        final mockUser = UserModel(name: "john", email: "john@example.com");
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: child,
              routes: {
                AuthenticationTransmissionScreen.routeName: (context) =>
                    AuthenticationTransmissionScreen(),
              },
            ),
          );
        }

        final testWidget = SignUpFlow();

        when(() => mockRepo.register(any())).thenAnswer((_) async => mockUser);

        notifier.state = const AuthenticationState.signup(
          currentSignupStep: 2,
          name: 'John',
          email: 'john@example.com',
          date: '2000-01-01',
          code: "123456",
          passwordSignup: "Test1234!",
          isValidName: true,
          isValidEmail: true,
          isValidDate: true,
          isValidCode: true,
          isValidSignupPassword: true,
        );

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();

        final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        verify(
          () => mockRepo.register(
            AuthenticationUserDataModel(
              name: "John",
              email: 'john@example.com',
              password: "Test1234!",
              birthDate: '2000-01-01',
            ),
          ),
        ).called(1);
        expect(find.byKey(ValueKey("transmissionAfterLogin")), findsOne);

        container.dispose();
      },
    );
    testWidgets('should show error message when wrong otp', (tester) async {
      final container = createContainer();
      final notifier = container.read(authenticationViewmodelProvider.notifier);
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final testWidget = SignUpFlow();

      when(
        () => mockRepo.verifyOTP(any(), any()),
      ).thenAnswer((_) async => false);

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        name: 'John Doe',
        email: 'john@example.com',
        date: '2000-01-01',
        code: "123456",
        isValidName: true,
        isValidEmail: true,
        isValidDate: true,
        isValidCode: true,
        toastMessage: AuthenticationConstants.errorEmailMessage,
      );

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
      expect(nextButton, findsOneWidget);

      await tester.tap(nextButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(ValueKey("signupMessage")), findsOne);
    });
    testWidgets('login after signup', (tester) async {
      final container = createContainer();
      final notifier = container.read(authenticationViewmodelProvider.notifier);
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        name: 'john',
        email: 'john@example.com',
        date: '2000-01-01',
        code: "123456",
        passwordSignup: "Test1234!",
        isValidName: true,
        isValidEmail: true,
        isValidDate: true,
        isValidCode: true,
        isValidSignupPassword: true,
        toastMessage: AuthenticationConstants.errorEmailMessage,
      );
        final mockUser = UserModel(name: "john", email: "john@example.com");

      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: child,
            routes: {
              AuthenticationTransmissionScreen.routeName: (context) =>
                  AuthenticationTransmissionScreen(),
            },
          ),
        );
      }

      final testWidget = SignUpFlow();

      when(
        () => mockRepo.register(any()),
      ).thenAnswer((_) async => mockUser);

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      final nextButton = find.byKey(const ValueKey('nextSignupStepButton'));
      expect(nextButton, findsOneWidget);

      await tester.tap(nextButton);
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      final authNotifier = container.read(authenticationProvider);
      expect(authNotifier.isAuthenticated, true);
      expect(find.byKey(ValueKey("transmissionAfterLogin")), findsOne);
    });
    testWidgets('test loading indicator finishes', (tester) async {
      final container = createContainer();
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final notifier = getNotifier(container);
      notifier.state = const AuthenticationState.signup(isLoadingSignup: false);
      final testWidget = SignUpFlow();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));

      expect(find.byKey(const ValueKey('mainData')), findsOneWidget);

      container.dispose();
    });

  });
}
