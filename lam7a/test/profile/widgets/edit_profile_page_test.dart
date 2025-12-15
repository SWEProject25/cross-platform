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
}
