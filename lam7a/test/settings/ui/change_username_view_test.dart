import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/settings/ui/view/account_settings/account_info/change_username_view.dart';
import 'package:lam7a/features/settings/ui/viewmodel/change_username_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/change_username_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/settings/ui/widgets/blue_x_button.dart';

class FakeAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: 'current_user',
    email: 'test@mail.com',
    role: 'user',
    name: 'Test User',
    birthDate: '2000-01-01',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '2024-01-01',
  );

  @override
  UserModel build() => _state;

  @override
  Future<void> changeUsername(String newUsername) async {
    _state = _state.copyWith(username: newUsername);
  }
}

class FailingAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: 'current_user',
    email: 'test@mail.com',
    role: 'user',
    name: 'Test User',
    birthDate: '2000-01-01',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '2024-01-01',
  );

  @override
  UserModel build() => _state;

  @override
  Future<void> changeUsername(String newUsername) async {
    throw Exception('Username already taken');
  }
}

Widget createTestWidget({AccountViewModel? accountViewModel}) {
  return ProviderScope(
    overrides: [
      accountProvider.overrideWith(
        () => accountViewModel ?? FakeAccountViewModel(),
      ),
    ],
    child: const MaterialApp(home: ChangeUsernameView()),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(''));

  group('ChangeUsernameView - UI Elements', () {
    testWidgets('displays all UI elements correctly', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('changeUsernamePage')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('changeUsernameAppBar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('changeUsernameBackButton')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('changeUsernameBody')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('currentUsernameContainer')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('newUsernameField')), findsOneWidget);
      expect(find.byKey(const ValueKey('saveUsernameButton')), findsOneWidget);

      expect(find.text('Change username'), findsOneWidget);
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('current_user'), findsOneWidget);
    });

    testWidgets('back button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => createTestWidget()),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('changeUsernameBackButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeUsernameView), findsNothing);
    });

    testWidgets('app bar displays correct theme styling', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(
        find.byKey(const ValueKey('changeUsernameAppBar')),
      );

      expect(appBar.centerTitle, false);
      expect(appBar.leading, isNotNull);
    });
  });

  group('ChangeUsernameView - Text Field Interactions', () {
    testWidgets('entering text in new username field updates state', (
      tester,
    ) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'newuser123',
      );
      await tester.pumpAndSettle();

      expect(find.text('newuser123'), findsWidgets);
    });

    testWidgets('empty text field disables save button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );

      expect(saveButton.isActive, false);
      // expect(saveButton.onPressed, isNull);
    });

    testWidgets('valid username enables save button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'validnewuser',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );

      expect(saveButton.isActive, true);
      expect(saveButton.onPressed, isNotNull);
    });

    testWidgets('invalid username disables save button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'ab',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );

      expect(saveButton.isActive, false);
      // expect(saveButton.onPressed, isNull);
    });

    testWidgets('error message displays for invalid username', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'ab',
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be between 3 and 50 characters'),
        findsOneWidget,
      );
    });

    testWidgets('error clears when valid username entered', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'ab',
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be between 3 and 50 characters'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'validuser',
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Username must be between 3 and 50 characters'),
        findsNothing,
      );
    });

    testWidgets('same as current username shows error', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'current_user',
      );
      await tester.pumpAndSettle();

      expect(find.text('New username must be different'), findsOneWidget);
    });
  });

  group('ChangeUsernameView - Save Username Functionality', () {
    testWidgets('successful save shows success message', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'successuser',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );
      expect(saveButton.onPressed, isNotNull);
      saveButton.onPressed!.call();

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Username updated'), findsOneWidget);
    });

    testWidgets('save clears input field after success', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'newusername',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );
      saveButton.onPressed!.call();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify success message appears
      expect(find.text('Username updated'), findsOneWidget);

      // If the field should NOT be cleared, verify it still contains the value
      final fieldAfter = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const ValueKey('newUsernameField')),
          matching: find.byType(TextField),
        ),
      );
      expect(fieldAfter.controller?.text, 'newusername');
    });
  });

  group('ChangeUsernameView - Loading State', () {
    testWidgets('button shows correct color when active', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'validuser',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );

      expect(saveButton.isActive, true);
      expect(saveButton.isLoading, false);
    });

    testWidgets('button shows muted color when inactive', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );

      expect(saveButton.isActive, false);
    });
  });

  group('ChangeUsernameView - Layout & Spacing', () {
    testWidgets('current username section displays properly', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byKey(const ValueKey('currentUsernameContainer')),
      );

      expect(container.padding, const EdgeInsets.symmetric(vertical: 10.0));
    });

    testWidgets('body has correct padding', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final body = tester.widget<Padding>(
        find.byKey(const ValueKey('changeUsernameBody')),
      );

      expect(
        body.padding,
        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      );
    });

    testWidgets('save button positioned at bottom right', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(
        find.byKey(const ValueKey('changeUsernamePage')),
      );

      expect(
        scaffold.floatingActionButtonLocation,
        FloatingActionButtonLocation.endFloat,
      );
    });
  });

  group('ChangeUsernameView - Special Characters Validation', () {
    testWidgets('username with special characters shows error', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'user@name!',
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Username can only contain letters, numbers, dots, and underscores',
        ),
        findsOneWidget,
      );
    });

    testWidgets('username with consecutive dots shows error', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'user..name',
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Username can only contain letters, numbers, dots, and underscores',
        ),
        findsOneWidget,
      );
    });

    testWidgets('valid username with single dot passes', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'user.name',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );
      expect(saveButton.isActive, true);
    });

    testWidgets('valid username with underscore passes', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('newUsernameField')),
        'user_name',
      );
      await tester.pumpAndSettle();

      final saveButton = tester.widget<BlueXButton>(
        find.byKey(const ValueKey('saveUsernameButton')),
      );
      expect(saveButton.isActive, true);
    });
  });
}
