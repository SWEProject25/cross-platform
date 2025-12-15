import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/view/followers_following_page.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  Widget _wrap(Widget child, FakeProfileApiService api) {
    return ProviderScope(
      overrides: [
        profileApiServiceProvider.overrideWithValue(api),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('shows empty followers and following states', (tester) async {
    final api = FakeProfileApiService()
      ..followers = []
      ..following = [];

    await tester.pumpWidget(
      _wrap(
        const FollowersFollowingPage(userId: 1),
        api,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('followers_empty')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('following_tab')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('following_empty')), findsOneWidget);
  });

  testWidgets('renders followers list', (tester) async {
    final api = FakeProfileApiService()
      ..followers = [
        {
          'id': 10,
          'username': 'follower1',
          'name': 'Follower One',
          'bio': 'Hello',
        }
      ]
      ..following = [];

    await tester.pumpWidget(
      _wrap(
        const FollowersFollowingPage(userId: 1),
        api,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('followers_list')), findsOneWidget);
    expect(find.byKey(const ValueKey('user_tile_10')), findsOneWidget);
    expect(find.byKey(const ValueKey('user_name_10')), findsOneWidget);
    expect(find.text('Follower One'), findsOneWidget);
  });

  testWidgets('renders following list when switching tab', (tester) async {
    final api = FakeProfileApiService()
      ..followers = []
      ..following = [
        {
          'id': 20,
          'username': 'following1',
          'name': 'Following One',
        }
      ];

    await tester.pumpWidget(
      _wrap(
        const FollowersFollowingPage(userId: 1),
        api,
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('following_tab')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('following_list')), findsOneWidget);
    expect(find.byKey(const ValueKey('user_tile_20')), findsOneWidget);
    expect(find.text('Following One'), findsOneWidget);
  });

  testWidgets('pop returns false when no changes happened', (tester) async {
    final api = FakeProfileApiService()
      ..followers = []
      ..following = [];

    bool? popResult;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  popResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FollowersFollowingPage(userId: 1),
                    ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(popResult, false);
  });

  testWidgets('tapping user tile marks page as changed', (tester) async {
    final api = FakeProfileApiService()
      ..followers = [
        {'id': 1, 'username': 'user1', 'name': 'User One'}
      ]
      ..following = [];

    bool? result;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileApiServiceProvider.overrideWithValue(api),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FollowersFollowingPage(userId: 1),
                    ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('user_tile_1')));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(result, true);
  });



}
