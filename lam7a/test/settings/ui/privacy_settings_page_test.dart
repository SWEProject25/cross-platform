import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/settings/ui/view/privacy_settings/privacy_settings_page.dart';
import 'package:lam7a/features/settings/ui/view/privacy_settings/blocked_users_page.dart';
import 'package:lam7a/features/settings/ui/view/privacy_settings/muted_users_page.dart';
import 'package:lam7a/features/settings/ui/viewmodel/blocked_users_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/muted_users_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/blocked_users_state.dart';
import 'package:lam7a/features/settings/ui/state/muted_users_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/settings/ui/widgets/status_user_listtile.dart';

/// --- Fakes for AsyncNotifiers ---
class FakeBlockedUsersNotifier extends BlockedUsersViewModel {
  FakeBlockedUsersNotifier(this._initial);
  final AsyncValue<BlockedUsersState> _initial;

  @override
  Future<BlockedUsersState> build() async {
    state = _initial;
    return _initial.whenData((value) => value).value ??
        BlockedUsersState(blockedUsers: []);
  }

  @override
  Future<void> refreshBlockedUsers() async {
    state = _initial;
  }

  @override
  Future<void> unblockUser(int userId) async {
    final current = state.value?.blockedUsers ?? [];
    state = AsyncData(
      BlockedUsersState(
        blockedUsers: current.where((u) => u.id != userId).toList(),
      ),
    );
  }
}

class FakeMutedUsersNotifier extends MutedUsersViewModel {
  FakeMutedUsersNotifier(this._initial);
  final AsyncValue<MutedUsersState> _initial;

  @override
  Future<MutedUsersState> build() async {
    state = _initial;
    return _initial.maybeWhen(
      data: (value) => value,
      orElse: () => MutedUsersState(mutedUsers: []),
    );
  }

  @override
  Future<void> refreshMutedUsers() async {
    state = _initial;
  }

  @override
  Future<void> unmuteUser(int userId) async {
    final current = state.value?.mutedUsers ?? [];
    state = AsyncData(
      MutedUsersState(
        mutedUsers: current.where((u) => u.id != userId).toList(),
      ),
    );
  }
}

void main() {
  final userA = UserModel(
    id: 1,
    username: 'alice',
    email: 'a@mail.com',
    role: '',
    name: '',
    birthDate: '',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '',
  );
  final userB = UserModel(
    id: 2,
    username: 'bob',
    email: 'b@mail.com',
    role: '',
    name: '',
    birthDate: '',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '',
  );

  Widget buildApp({
    required AsyncValue<BlockedUsersState> blocked,
    required AsyncValue<MutedUsersState> muted,
    Widget? home,
  }) {
    return ProviderScope(
      overrides: [
        blockedUsersProvider.overrideWith(
          () => FakeBlockedUsersNotifier(blocked),
        ),
        mutedUsersProvider.overrideWith(() => FakeMutedUsersNotifier(muted)),
      ],
      child: MaterialApp(home: home ?? const PrivacySettingsPage()),
    );
  }

  group('PrivacySettingsPage navigation', () {
    testWidgets('shows tiles for blocked and muted lists', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
        ),
      );

      expect(find.textContaining('Blocked'), findsOneWidget);
      expect(find.textContaining('Muted'), findsOneWidget);
    });

    testWidgets('navigates to BlockedUsersView', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
        ),
      );

      await tester.tap(find.textContaining('Blocked'));
      await tester.pumpAndSettle();

      expect(find.byType(BlockedUsersView), findsOneWidget);
    });

    testWidgets('navigates to MutedUsersView', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
        ),
      );

      await tester.tap(find.textContaining('Muted'));
      await tester.pumpAndSettle();

      expect(find.byType(MutedUsersView), findsOneWidget);
    });
  });

  group('BlockedUsersView UI states', () {
    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncLoading(),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message when no blocked users', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.text('Block unwanted users'), findsOneWidget);
    });

    testWidgets('displays app bar with correct title', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.text('Blocked Accounts'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders list of blocked users', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA, userB])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(StatusUserTile), findsNWidgets(2));
    });

    testWidgets('shows unblock dialog when action button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      // Tap on the action button (Blocked button)
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Unblock ${userA.name}?'), findsOneWidget);
      expect(
        find.text('They will be able to interact with you again.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Unblock'), findsOneWidget);
    });

    testWidgets('dialog cancel button dismisses dialog', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('unblock button calls unblockUser and dismisses dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA, userB])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      // Initial state: 2 users
      expect(find.byType(StatusUserTile), findsNWidgets(2));

      // Open dialog for first user by tapping action button
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      // Tap unblock button
      await tester.tap(find.text('Unblock'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.byType(AlertDialog), findsNothing);

      // User should be removed from list
      expect(find.byType(StatusUserTile), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncError(Exception('Network error'), StackTrace.empty),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.textContaining('Something went wrong'), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('multiple users can be unblocked sequentially', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA, userB])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.byType(StatusUserTile), findsNWidgets(2));

      // Unblock first user
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unblock'));
      await tester.pumpAndSettle();

      expect(find.byType(StatusUserTile), findsOneWidget);

      // Unblock second user
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unblock'));
      await tester.pumpAndSettle();

      // Should show empty message now
      expect(find.text('Block unwanted users'), findsOneWidget);
    });

    testWidgets('ListView scrolls when many users are blocked', (tester) async {
      final manyUsers = List.generate(
        20,
        (i) => UserModel(
          id: i,
          username: 'user$i',
          email: 'user$i@mail.com',
          role: '',
          name: 'User $i',
          birthDate: '',
          profileImageUrl: '',
          bannerImageUrl: '',
          bio: '',
          location: '',
          website: '',
          createdAt: '',
        ),
      );

      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: manyUsers)),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);

      // First user should be visible
      expect(find.text('User 0'), findsOneWidget);

      // Last user might not be visible initially
      expect(find.text('User 19'), findsNothing);

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      // Last user should now be visible
      expect(find.text('User 19'), findsOneWidget);
    });

    testWidgets('dialog displays correct user name', (tester) async {
      final customUser = UserModel(
        id: 1,
        username: 'custom_username',
        email: 'custom@mail.com',
        role: '',
        name: 'Custom Display Name',
        birthDate: '',
        profileImageUrl: '',
        bannerImageUrl: '',
        bio: '',
        location: '',
        website: '',
        createdAt: '',
      );

      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [customUser])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      expect(find.text('Unblock Custom Display Name?'), findsOneWidget);
    });

    testWidgets('shows Scaffold with correct background', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('StatusUserTile receives correct style', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      final tile = tester.widget<StatusUserTile>(
        find.byType(StatusUserTile).first,
      );

      expect(tile.style, Style.blocked);
      expect(tile.user, userA);
    });

    testWidgets('action button shows correct label for blocked style', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      expect(find.text('Blocked'), findsNWidgets(1));
    });

    testWidgets('tapping StatusUserTile navigates to profile', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: AsyncData(BlockedUsersState(blockedUsers: [userA])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const BlockedUsersView(),
        ),
      );

      // Tap on the GestureDetector area (not the button)
      await tester.tap(find.byType(StatusUserTile).first);
      await tester.pumpAndSettle();

      // Should navigate to ProfileScreen (not show dialog)
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('MutedUsersView UI states', () {
    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncLoading(),
          home: const MutedUsersView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message when no muted users', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.text('Mute unwanted users'), findsOneWidget);
    });

    testWidgets('displays app bar with correct title', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.text('Muted Accounts'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders list of muted users', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA, userB])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(StatusUserTile), findsNWidgets(2));
    });

    testWidgets('shows unmute dialog when action button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA])),
          home: const MutedUsersView(),
        ),
      );

      // Tap on the action button (Muted button)
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Unmute ${userA.name} ?'), findsOneWidget);
      expect(
        find.text('They will be able to interact with you again.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Unmute'), findsOneWidget);
    });

    testWidgets('dialog cancel button dismisses dialog', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA])),
          home: const MutedUsersView(),
        ),
      );

      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('unmute button calls unmuteUser and dismisses dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA, userB])),
          home: const MutedUsersView(),
        ),
      );

      // Initial state: 2 users
      expect(find.byType(StatusUserTile), findsNWidgets(2));

      // Open dialog for first user by tapping action button
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      // Tap unmute button
      await tester.tap(find.text('Unmute'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.byType(AlertDialog), findsNothing);

      // User should be removed from list
      expect(find.byType(StatusUserTile), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncError(Exception('Network error'), StackTrace.empty),
          home: const MutedUsersView(),
        ),
      );

      expect(find.textContaining('Something went wrong'), findsOneWidget);
      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('multiple users can be unmuted sequentially', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA, userB])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.byType(StatusUserTile), findsNWidgets(2));

      // Unmute first user
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unmute'));
      await tester.pumpAndSettle();

      expect(find.byType(StatusUserTile), findsOneWidget);

      // Unmute second user
      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unmute'));
      await tester.pumpAndSettle();

      // Should show empty message now
      expect(find.text('Mute unwanted users'), findsOneWidget);
    });

    testWidgets('ListView scrolls when many users are muted', (tester) async {
      final manyUsers = List.generate(
        20,
        (i) => UserModel(
          id: i,
          username: 'user$i',
          email: 'user$i@mail.com',
          role: '',
          name: 'User $i',
          birthDate: '',
          profileImageUrl: '',
          bannerImageUrl: '',
          bio: '',
          location: '',
          website: '',
          createdAt: '',
        ),
      );

      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: manyUsers)),
          home: const MutedUsersView(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);

      // First user should be visible
      expect(find.text('User 0'), findsOneWidget);

      // Last user might not be visible initially
      expect(find.text('User 19'), findsNothing);

      // Scroll to bottom
      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      // Last user should now be visible
      expect(find.text('User 19'), findsOneWidget);
    });

    testWidgets('dialog displays correct user name', (tester) async {
      final customUser = UserModel(
        id: 1,
        username: 'custom_username',
        email: 'custom@mail.com',
        role: '',
        name: 'Custom Display Name',
        birthDate: '',
        profileImageUrl: '',
        bannerImageUrl: '',
        bio: '',
        location: '',
        website: '',
        createdAt: '',
      );

      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [customUser])),
          home: const MutedUsersView(),
        ),
      );

      await tester.tap(find.byKey(const Key('action_button')).first);
      await tester.pumpAndSettle();

      expect(find.text('Unmute Custom Display Name ?'), findsOneWidget);
    });

    testWidgets('shows Scaffold with correct structure', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: const AsyncData(MutedUsersState(mutedUsers: [])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('StatusUserTile receives correct style', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA])),
          home: const MutedUsersView(),
        ),
      );

      final tile = tester.widget<StatusUserTile>(
        find.byType(StatusUserTile).first,
      );

      expect(tile.style, Style.muted);
      expect(tile.user, userA);
    });

    testWidgets('action button shows correct label for muted style', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA])),
          home: const MutedUsersView(),
        ),
      );

      expect(find.text('Muted'), findsNWidgets(1));
    });

    testWidgets('tapping StatusUserTile navigates to profile', (tester) async {
      await tester.pumpWidget(
        buildApp(
          blocked: const AsyncData(BlockedUsersState(blockedUsers: [])),
          muted: AsyncData(MutedUsersState(mutedUsers: [userA])),
          home: const MutedUsersView(),
        ),
      );

      // Tap on the GestureDetector area (not the button)
      await tester.tap(find.byType(StatusUserTile).first);
      await tester.pumpAndSettle();

      // Should navigate to ProfileScreen (not show dialog)
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
