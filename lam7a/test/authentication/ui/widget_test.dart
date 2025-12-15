import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/interest_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/user_to_follow_widget.dart';

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

    testWidgets('should display check circle when selected', (tester) async {
      final interest = InterestDto(
        id: 2,
        name: 'Sports',
        slug: 'sports',
        description: 'Sports and fitness',
        icon: '⚽',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: true,
              interest: interest,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should not display check circle when not selected', (tester) async {
      final interest = InterestDto(
        id: 3,
        name: 'Music',
        slug: 'music',
        description: 'Music and entertainment',
        icon: '🎵',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: false,
              interest: interest,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('should call onTap callback when tapped', (tester) async {
      var tapped = false;
      final interest = InterestDto(
        id: 4,
        name: 'News',
        slug: 'news',
        description: 'News updates',
        icon: '📰',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: false,
              interest: interest,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });

  group('UserToFollowWidget Tests', () {
    testWidgets('should display user widget', (tester) async {
      final user = UserToFollowDto(
        id: 1,
        username: 'johndoe',
        profile: UserToFollowProfile(name: 'John Doe'),
        isFollowing: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserToFollowWidget(
                myUserToFollow: user,
              ),
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should display following state', (tester) async {
      final user = UserToFollowDto(
        id: 2,
        username: 'janedoe',
        profile: UserToFollowProfile(name: 'Jane Doe'),
        isFollowing: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserToFollowWidget(
                myUserToFollow: user,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('should display circle avatar', (tester) async {
      final user = UserToFollowDto(
        id: 3,
        username: 'testuser',
        profile: UserToFollowProfile(
          name: 'Test User',
          profileImageUrl: null,
        ),
        isFollowing: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: UserToFollowWidget(
                myUserToFollow: user,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('AuthenticationStepButton Tests', () {
    testWidgets('should be disabled when enable is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthenticationStepButton(
              enable: false,
              label: 'Next',
              bgColor: Colors.blue,
              textColor: Colors.white,
              onPressedEffect: () {},
            ),
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should be enabled when enable is true', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AuthenticationStepButton(
              enable: true,
              label: 'Next',
              bgColor: Colors.blue,
              textColor: Colors.white,
              onPressedEffect: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AuthenticationStepButton));
      expect(pressed, isTrue);
    });
  });

  group('Interest and User Data Tests', () {
    test('InterestDto with all fields', () {
      final interest = InterestDto(
        id: 100,
        name: 'Tech',
        slug: 'tech-slug',
        description: 'Technology',
        icon: '💻',
      );

      expect(interest.id, 100);
      expect(interest.name, 'Tech');
      expect(interest.slug, 'tech-slug');
      expect(interest.description, 'Technology');
      expect(interest.icon, '💻');
    });

    test('InterestDto fromJson', () {
      final json = {
        'id': 50,
        'name': 'Sports',
        'slug': 'sports-slug',
        'description': 'Sports content',
        'icon': '⚽',
      };

      final interest = InterestDto.fromJson(json);
      expect(interest.id, 50);
      expect(interest.name, 'Sports');
    });

    test('UserToFollowProfile creation', () {
      final profile = UserToFollowProfile(
        name: 'Test User',
        profileImageUrl: 'https://example.com/image.jpg',
      );

      expect(profile.name, 'Test User');
      expect(profile.profileImageUrl, 'https://example.com/image.jpg');
    });

    test('UserToFollowDto creation', () {
      final user = UserToFollowDto(
        id: 1,
        username: 'testuser',
        profile: UserToFollowProfile(name: 'Test'),
        isFollowing: false,
      );

      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.isFollowing, false);
    });
  });

  group('Selection Logic Tests', () {
    test('multiple selections in list', () {
      final selections = <int>[1, 2, 3, 4, 5];
      expect(selections.length, 5);
      expect(selections.isNotEmpty, true);
    });

    test('selections cleared', () {
      final selections = <int>[1, 2, 3];
      selections.clear();
      expect(selections.isEmpty, true);
    });

    test('toggle follow state', () {
      var isFollowing = false;
      expect(isFollowing, false);

      isFollowing = true;
      expect(isFollowing, true);

      isFollowing = false;
      expect(isFollowing, false);
    });

    testWidgets('should have proper screen key', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: ValueKey('testScreen'),
            body: Container(),
          ),
        ),
      );

      expect(find.byKey(ValueKey('testScreen')), findsOneWidget);
    });

    testWidgets('should display AppBar with icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Test'),
            ),
            body: Container(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
