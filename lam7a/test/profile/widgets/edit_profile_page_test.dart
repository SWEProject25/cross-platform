import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/view/edit_profile_page.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import 'package:lam7a/core/models/user_model.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  testWidgets('valid profile edit saves and pops', (tester) async {
    final fakeApi = FakeProfileApiService();

    final user = UserModel(
      id: 1,
      profileId: 1,
      username: 'hossam',
      name: 'Hossam Old',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(
          home: EditProfilePage(user: user),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('edit_profile_name_field')),
      'Hossam New',
    );

    await tester.tap(
      find.byKey(const ValueKey('edit_profile_save_button')),
    );

    await tester.pumpAndSettle();

    // Page should be popped → Edit profile no longer visible
    expect(find.text('Edit profile'), findsNothing);
  });

  testWidgets('shows error when name is too short', (tester) async {
    final fakeApi = FakeProfileApiService();
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('edit_profile_name_field')),
      'abc',
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('Name must be'), findsOneWidget);
  });

  testWidgets('shows error when name is too long', (tester) async {
    final fakeApi = FakeProfileApiService();
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('edit_profile_name_field')),
      'a' * 31,
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('Name must be'), findsOneWidget);
  });
  testWidgets('shows error when website is invalid', (tester) async {
    final fakeApi = FakeProfileApiService();
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('edit_profile_website_field')),
      'not a url 😅',
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('valid website'), findsOneWidget);
  });

  testWidgets('shows error when birth year is invalid format', (tester) async {
    final fakeApi = FakeProfileApiService();
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('edit_profile_birthdate_field')),
      'abcd-01-01',
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('Birth year must be'), findsOneWidget);
  });

  testWidgets('avatar picker updates image', (tester) async {
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_avatar_picker')));
    await tester.pump();

    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('banner picker updates image', (tester) async {
    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: EditProfilePage(user: user)),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_banner_picker')));
    await tester.pump();

    expect(find.byType(Image), findsWidgets);
  });

testWidgets('save button is disabled while saving', (tester) async {
  final fakeApi = FakeProfileApiService()
    ..delayUpdate = true;

  final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
      child: MaterialApp(home: EditProfilePage(user: user)),
    ),
  );

  await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
  await tester.pump();

  final button =
      tester.widget<TextButton>(find.byKey(const ValueKey('edit_profile_save_button')));

  expect(button.onPressed, isNull);
});

testWidgets('save button is disabled while saving', (tester) async {
  final fakeApi = FakeProfileApiService()
    ..delayUpdate = true;

  final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
      child: MaterialApp(home: EditProfilePage(user: user)),
    ),
  );

  await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
  await tester.pump();

  final button = tester.widget<TextButton>(
    find.byKey(const ValueKey('edit_profile_save_button')),
  );

  expect(button.onPressed, isNull);
});


}
