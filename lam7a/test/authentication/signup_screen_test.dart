import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
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
  });
}
