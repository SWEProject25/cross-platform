import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/view/screens/following_screen/following_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/users_to_follow_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/interest_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:lam7a/features/authentication/ui/widgets/user_to_follow_widget.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState(
      isAuthenticated: true,
      user: UserModel(
        id: 1,
        name: 'Test User',
        followingCount: 0,
        followersCount: 0,
      ),
    );
  }

  @override
  void updateUser(UserModel updatedUser) {
    state = state.copyWith(user: updatedUser);
  }

  @override
  void authenticateUser(UserDtoAuth? user) {}

  @override
  Future<void> isAuthenticated() async {}

  @override
  UserModel userDtoToUserModel(UserDtoAuth dto) {
    return UserModel(id: dto.id, name: dto.name);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InterestWidget Tests', () {
    testWidgets('should display interest name, icon, and description', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        description: 'All about tech',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('💻'), findsOneWidget);
      expect(find.text('All about tech'), findsOneWidget);
    });

    testWidgets('should show check icon when selected', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: true,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should not show check icon when not selected', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool wasTapped = false;
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('should have different styling when selected', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: true,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF635BFF));
      expect(decoration.border?.top.color, const Color(0xFF1C478B));
    });

    testWidgets('should have different styling when not selected in light mode',
        (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFF2F2F7));
    });

    testWidgets('should handle dark mode styling', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(InterestWidget), findsOneWidget);
    });

    testWidgets('should handle multiple taps', (tester) async {
      int tapCount = 0;
      final interest = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InterestWidget(
                isSelected: false,
                interest: interest,
                onTap: () {
                  tapCount++;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapCount, 3);
    });
  });

  group('UserToFollowWidget Tests', () {
    late MockAuthenticationRepositoryImpl mockRepo;
    late FakeAuthentication fakeAuth;

    setUp(() {
      mockRepo = MockAuthenticationRepositoryImpl();
      fakeAuth = FakeAuthentication();
    });

    Widget createUserWidget(UserToFollowDto user) {
      return ProviderScope(
        overrides: [
          authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          authenticationProvider.overrideWith(() => fakeAuth),

        ],
        child: MaterialApp(
          home: Scaffold(
            body: UserToFollowWidget(myUserToFollow: user),
          ),
        ),
      );
    }

    testWidgets('should display user profile information', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        email: 'john@example.com',
        profile: UserToFollowProfile(
          name: 'John Doe',
          bio: 'Software developer',
          profileImageUrl: 'https://example.com/image.jpg',
        ),
        followersCount: 100,
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@johndoe'), findsOneWidget);
      expect(find.text('Software developer'), findsOneWidget);
    });

    testWidgets('should display default values when profile fields are null',
        (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: null,
        profile: UserToFollowProfile(
          name: null,
          bio: null,
        ),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.text('User Name'), findsOneWidget);
      expect(find.text('@username'), findsOneWidget);
      expect(find.text('Bio goes here'), findsOneWidget);
    });

    testWidgets('should display Follow button when not following', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('should display Following button when following', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: true,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('should call followUser when Follow button tapped', (tester) async {
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.followUser(1)).called(1);
    });

    testWidgets('should call unfollowUser when Following button tapped',
        (tester) async {
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: true,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Following'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.unFollowUser(1)).called(1);
    });

    testWidgets('should show loading indicator when button is processing',
        (tester) async {
      when(() => mockRepo.followUser(any())).thenAnswer(
        (_) async => Future.delayed(Duration(milliseconds: 500), () => true),
      );

      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Follow'));
      await tester.pump();
      await tester.pump(Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should update following count when following', (tester) async {
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      final initialCount =
          fakeAuth.state.user!.followingCount;

      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();

      expect(fakeAuth.state.user!.followingCount, initialCount + 1);
    });

    testWidgets('should handle error during follow/unfollow', (tester) async {
      when(() => mockRepo.followUser(any())).thenThrow(Exception('Network error'));

      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John'),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.byType(UserToFollowWidget), findsOneWidget);
    });

    testWidgets('should display CircleAvatar with profile image', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(
          name: 'John',
          profileImageUrl: 'https://example.com/image.jpg',
        ),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display placeholder when no profile image', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(
          name: 'John',
          profileImageUrl: null,
        ),
        isFollowing: false,
      );

      await tester.pumpWidget(createUserWidget(user));
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('FollowingScreen Tests', () {
    late MockAuthenticationRepositoryImpl mockRepo;
    late FakeAuthentication fakeAuth;

    setUp(() {
      mockRepo = MockAuthenticationRepositoryImpl();
      fakeAuth = FakeAuthentication();
    });

    Widget createFollowingScreen(List<UserToFollowDto> users) {
      return ProviderScope(
        overrides: [
          authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
          authenticationProvider.overrideWith(() => fakeAuth),
        ],
        child: MaterialApp(
          home: FollowingScreen(),
          routes: {
            NavigationHomeScreen.routeName: (context) => Scaffold(
                  key: Key('home_screen'),
                  body: Text('Home Screen'),
                ),
          },
        ),
      );
    }

    testWidgets('should display list of users', (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          username: 'user2',
          profile: UserToFollowProfile(name: 'User 2'),
          isFollowing: false,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      expect(find.byType(UserToFollowWidget), findsNWidgets(2));
    });



    testWidgets('should enable Next button when at least one user is followed',
        (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: true,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      final button = tester.widget<AuthenticationStepButton>(
        find.byKey(Key('interestsNextButton')),
      );

      expect(button.enable, true);
    });

    testWidgets('should disable Next button when no users are followed',
        (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: false,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      final button = tester.widget<AuthenticationStepButton>(
        find.byKey(Key('interestsNextButton')),
      );

      expect(button.enable, false);
    });

    testWidgets('should navigate to home when Next is tapped', (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: true,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('interestsNextButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('home_screen')), findsOneWidget);
    });

    testWidgets('should not navigate when Next tapped and not authenticated',
        (tester) async {
      fakeAuth.state = AuthState(isAuthenticated: false);

      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: true,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('interestsNextButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('followingScreen')), findsOneWidget);
    });

    testWidgets('should display dividers between users', (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          username: 'user2',
          profile: UserToFollowProfile(name: 'User 2'),
          isFollowing: false,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('should handle empty user list', (tester) async {
      await tester.pumpWidget(createFollowingScreen([]));
      await tester.pumpAndSettle();

      expect(find.byType(UserToFollowWidget), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should have proper screen key', (tester) async {
      await tester.pumpWidget(createFollowingScreen([]));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey('followingScreen')), findsOneWidget);
    });

    testWidgets('should display AppBar with icon', (tester) async {
      await tester.pumpWidget(createFollowingScreen([]));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should use findoneFollowing correctly', (tester) async {
      final users = [
        UserToFollowDto(
          id: 1,
          username: 'user1',
          profile: UserToFollowProfile(name: 'User 1'),
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          username: 'user2',
          profile: UserToFollowProfile(name: 'User 2'),
          isFollowing: true,
        ),
      ];

      await tester.pumpWidget(createFollowingScreen(users));
      await tester.pumpAndSettle();

      final button = tester.widget<AuthenticationStepButton>(
        find.byKey(Key('interestsNextButton')),
      );

      expect(button.enable, true);
    });
  });
}
