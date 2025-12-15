import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/widgets/follow_button.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';

void main() {
  final baseUser = UserModel(
    id: 1,
    profileId: 1,
    username: 'alice',
    name: 'Alice',
  );

  testWidgets('shows "Follow" when not following and not following me',
      (tester) async {
    final user = baseUser.copyWith(
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateFollowingMe: ProfileStateFollowingMe.notfollowingme,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticationProvider.overrideWithValue(
            const AuthState(isAuthenticated: true, user: null),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: FollowButton(user: user)),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('follow_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('follow_button_label')), findsOneWidget);
    expect(find.text('Follow'), findsOneWidget);
  });

  testWidgets('shows "Follow Back" when following me but not following',
      (tester) async {
    final user = baseUser.copyWith(
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateFollowingMe: ProfileStateFollowingMe.followingme,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticationProvider.overrideWithValue(
            const AuthState(isAuthenticated: true, user: null),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: FollowButton(user: user)),
        ),
      ),
    );

    expect(find.text('Follow Back'), findsOneWidget);
  });

  testWidgets('shows "Following" when already following', (tester) async {
    final user = baseUser.copyWith(
      stateFollow: ProfileStateOfFollow.following,
      stateFollowingMe: ProfileStateFollowingMe.notfollowingme,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authenticationProvider.overrideWithValue(
            const AuthState(isAuthenticated: true, user: null),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: FollowButton(user: user)),
        ),
      ),
    );

    expect(find.text('Following'), findsOneWidget);
  });
}
