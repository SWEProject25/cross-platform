import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_otp_code_Step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthenticationUserCredentialsModel extends Fake
    implements AuthenticationUserCredentialsModel {}

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
    registerFallbackValue(FakeAuthenticationUserCredentialsModel());
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

  group('login Screen  Step Tests', () {
    testWidgets('should display identifier field on identifier step', (
      tester,
    ) async {
      final container = createContainer();
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final notifier = getNotifier(container);
      notifier.state = const AuthenticationState.login(currentLoginStep: 0);
      final testWidget = LogInScreen();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));

      expect(find.byKey(const Key('emailLoginTextField')), findsOneWidget);
      expect(find.byKey(const Key('loginNextButton')), findsOneWidget);

      container.dispose();
    });
    testWidgets(
      'should display password field and identifier in perform login',
      (tester) async {
        final container = createContainer();
        final notifier = getNotifier(container);
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child),
          );
        }

        notifier.state = const AuthenticationState.login(currentLoginStep: 1);
        final testWidget = LogInScreen();

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('emailLoginTextField')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('passwordLoginTextField')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('loginNextButton')), findsOneWidget);

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
      notifier.state = const AuthenticationState.login(isLoadingLogin: true);
      final testWidget = LogInScreen();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));

      expect(find.byKey(const ValueKey('loadingLogin')), findsOneWidget);

      container.dispose();
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
      notifier.state = const AuthenticationState.login(isLoadingLogin: false);
      final testWidget = LogInScreen();

      await tester.pumpWidget(createWidgetUnderTest(testWidget));

      expect(find.byKey(const ValueKey('mainLoginView')), findsOneWidget);

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
      notifier.state = const AuthenticationState.login(currentLoginStep: 0);
      final testWidget = LogInScreen();
      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();
      final backButton = find.byIcon(Icons.close);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('firstScreen')), findsOneWidget);

      container.dispose();
    });
    testWidgets('system back should return to previous login step', (
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
      notifier.state = const AuthenticationState.login(currentLoginStep: 1);

      final testWidget = LogInScreen();
      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(
        container.read(authenticationViewmodelProvider).currentLoginStep,
        0,
      );

      expect(find.byKey(const ValueKey('emailLoginTextField')), findsOneWidget);

      container.dispose();
    });

    testWidgets(
      'should call login when next button pressed on password step with valid data',
      (tester) async {
        final container = createContainer();
        final notifier = container.read(
          authenticationViewmodelProvider.notifier,
        );
        Widget createWidgetUnderTest(Widget child) {
          return UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: child, routes: {
              AuthenticationTransmissionScreen.routeName : (_) => AuthenticationTransmissionScreen()
            },),
          );
        }

        final testWidget = LogInScreen();

        when(() => mockRepo.login(any())).thenAnswer(
          (_) async => UserModel(name: "farouk", email: "far123@example.com"),
        );

        notifier.state = const AuthenticationState.login(
          identifier: "far123@example.com",
          currentLoginStep: 1,
          passwordLogin: "Test1234!",
        );

        await tester.pumpWidget(createWidgetUnderTest(testWidget));
        await tester.pumpAndSettle();

        final nextButton = find.byKey(const ValueKey('loginNextButton'));
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        verify(
          () => mockRepo.login(
            AuthenticationUserCredentialsModel(
              email: "far123@example.com",
              password: "Test1234!",
            ),
          ),
        ).called(1);
        expect(find.byKey(ValueKey("transmissionAfterLogin")), findsOne);
        container.dispose();
      },
    );
      testWidgets('should show error message when wrong credentials', (tester) async {
      final container = createContainer();
      final notifier = container.read(authenticationViewmodelProvider.notifier);
      Widget createWidgetUnderTest(Widget child) {
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: child),
        );
      }

      final testWidget = LogInScreen();

      when(
        () => mockRepo.verifyOTP(any(), any()),
      ).thenAnswer((_) async => false);

      notifier.state = const AuthenticationState.login(
          currentLoginStep: 1,
          identifier: "far123@example.com",
          passwordLogin: "Test1234!"
      );

      await tester.pumpWidget(createWidgetUnderTest(testWidget));
      await tester.pumpAndSettle();

      final nextButton = find.byKey(const ValueKey('loginNextButton'));
      expect(nextButton, findsOneWidget);

      await tester.tap(nextButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(ValueKey("loginMessage")), findsOne);
    });
   
  });
}
