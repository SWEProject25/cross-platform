import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import 'package:lam7a/features/profile/ui/widgets/blocked_profile_view.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_pagination.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_replies_pagination.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_likes_pagination.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/profile/ui/widgets/profile_header_widget.dart';



final testUser = UserModel(
  id: 1,
  profileId: 1,
  username: 'hossam',
  name: 'Hossam',
);




void main() {
  testWidgets('shows message when no username provided', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ProfileScreen()),
      ),
    );

    expect(find.text('No username provided'), findsOneWidget);
  });

  testWidgets('shows loading while profile loads', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileViewModelProvider('hossam')
              .overrideWithValue(const AsyncValue.loading()),
        ],
        child: MaterialApp(
          onGenerateRoute: (_) => MaterialPageRoute(
            settings: const RouteSettings(arguments: {'username': 'hossam'}),
            builder: (_) => const ProfileScreen(),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileViewModelProvider('hossam')
              .overrideWithValue(
                AsyncValue.error('boom', StackTrace.empty),
              ),
        ],
        child: MaterialApp(
          onGenerateRoute: (_) => MaterialPageRoute(
            settings: const RouteSettings(arguments: {'username': 'hossam'}),
            builder: (_) => const ProfileScreen(),
          ),
        ),
      ),
    );

    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('renders blocked profile view', (tester) async {
    final blockedUser =
        testUser.copyWith(stateBlocked: ProfileStateBlocked.blocked);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileViewModelProvider('hossam')
              .overrideWithValue(AsyncValue.data(blockedUser)),
        ],
        child: MaterialApp(
          onGenerateRoute: (_) => MaterialPageRoute(
            settings: const RouteSettings(arguments: {'username': 'hossam'}),
            builder: (_) => const ProfileScreen(),
          ),
        ),
      ),
    );

    expect(find.byType(BlockedProfileView), findsOneWidget);
  });


testWidgets('back button pops screen', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileViewModelProvider('hossam')
            .overrideWithValue(AsyncValue.data(testUser)),
      ],
      child: MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            settings: const RouteSettings(arguments: {'username': 'hossam'}),
            builder: (_) => const ProfileScreen(),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();

  expect(find.byType(ProfileScreen), findsNothing);
});




}
