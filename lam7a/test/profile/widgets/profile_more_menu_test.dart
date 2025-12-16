import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/widgets/profile_more_menu.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

import '../helpers/fake_profile_api.dart';

void main() {
  Widget wrap({
    required UserModel user,
    required FakeProfileApiService api,
    required VoidCallback onAction,
  }) {
    return ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(
          ProfileRepository(api),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              ProfileMoreMenu(
                user: user,
                username: user.username ?? '',
                onAction: onAction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  UserModel baseUser({
    ProfileStateOfMute mute = ProfileStateOfMute.notmuted,
    ProfileStateBlocked blocked = ProfileStateBlocked.notblocked,
  }) {
    return UserModel(
      id: 1,
      profileId: 1,
      username: 'test',
      name: 'Test User',
      stateMute: mute,
      stateBlocked: blocked,
    );
  }

  testWidgets('shows Mute and Block when user is not muted or blocked',
      (tester) async {
    final api = FakeProfileApiService();

    await tester.pumpWidget(
      wrap(
        user: baseUser(),
        api: api,
        onAction: () {},
      ),
    );

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mute'), findsOneWidget);
    expect(find.text('Block'), findsOneWidget);
  });

  testWidgets('tapping mute calls muteUser and onAction', (tester) async {
    final api = FakeProfileApiService();
    bool actionCalled = false;

    await tester.pumpWidget(
      wrap(
        user: baseUser(),
        api: api,
        onAction: () => actionCalled = true,
      ),
    );

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_mute')));
    await tester.pumpAndSettle();

    expect(api.muteCalled, true);
    expect(actionCalled, true);
  });

  testWidgets('tapping unmute calls unmuteUser', (tester) async {
    final api = FakeProfileApiService();

    await tester.pumpWidget(
      wrap(
        user: baseUser(mute: ProfileStateOfMute.muted),
        api: api,
        onAction: () {},
      ),
    );

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_button')));
    await tester.pumpAndSettle();

    expect(find.text('Unmute'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_mute')));
    await tester.pumpAndSettle();

    expect(api.unmuteCalled, true);
  });

  testWidgets('tapping block calls blockUser and onAction', (tester) async {
    final api = FakeProfileApiService();
    bool actionCalled = false;

    await tester.pumpWidget(
      wrap(
        user: baseUser(),
        api: api,
        onAction: () => actionCalled = true,
      ),
    );

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_block')));
    await tester.pumpAndSettle();

    expect(api.blockCalled, true);
    expect(actionCalled, true);
  });

  testWidgets('tapping unblock calls unblockUser', (tester) async {
    final api = FakeProfileApiService();

    await tester.pumpWidget(
      wrap(
        user: baseUser(blocked: ProfileStateBlocked.blocked),
        api: api,
        onAction: () {},
      ),
    );

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_button')));
    await tester.pumpAndSettle();

    expect(find.text('Unblock'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile_more_menu_block')));
    await tester.pumpAndSettle();

    expect(api.unblockCalled, true);
  });
}
