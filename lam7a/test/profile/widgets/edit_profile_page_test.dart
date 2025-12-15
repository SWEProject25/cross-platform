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

  testWidgets('shows error when name is invalid', (tester) async {
    final fakeApi = FakeProfileApiService();

    final user = UserModel(
      id: 1,
      profileId: 1,
      name: 'Old',
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
      '   ', // invalid
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('Name must be'), findsOneWidget);
  });

  testWidgets('shows error when birth year is too recent', (tester) async {
    final fakeApi = FakeProfileApiService();

    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

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
      find.byKey(const ValueKey('edit_profile_birthdate_field')),
      '2020-01-01',
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pump();

    expect(find.textContaining('Birth year must be'), findsOneWidget);
  });


  testWidgets('close button pops page', (tester) async {
    final user = UserModel(id: 1, profileId: 1, name: 'Name');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => EditProfilePage(user: user),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_close_button')));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfilePage), findsNothing);
  });


  testWidgets('normalizes website without http', (tester) async {
    final fakeApi = FakeProfileApiService();

    final user = UserModel(id: 1, profileId: 1, name: 'Valid Name');

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
      find.byKey(const ValueKey('edit_profile_website_field')),
      'example.com',
    );

    await tester.tap(find.byKey(const ValueKey('edit_profile_save_button')));
    await tester.pumpAndSettle();

    expect(fakeApi.updateCalled, true);
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
      'bad url 😅',
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

    expect(find.textContaining('Birth year'), findsOneWidget);
  });

  testWidgets('shows error when name is too short', (tester) async {
    final fakeApi = FakeProfileApiService();
    final user = UserModel(id: 1, profileId: 1, name: 'Ok Name');

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




}
