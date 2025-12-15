import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/widgets/blocked_profile_view.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  testWidgets('renders blocked profile and unblocks user',
      (tester) async {
    bool unblocked = false;

    final fakeApi = FakeProfileApiService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(fakeApi),
        ],
        child: MaterialApp(
          home: BlockedProfileView(
            username: 'blocked_user',
            userId: 99,
            onUnblock: () => unblocked = true,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('blocked_profile_screen')),
        findsOneWidget);
    expect(find.text('You blocked @blocked_user'), findsOneWidget);

    await tester.tap(
        find.byKey(const ValueKey('blocked_profile_unblock_button')));
    await tester.pumpAndSettle();

    expect(unblocked, true);
  });
}
