import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';

void main() {
  group('UserToFollowDto', () {
    group('Constructor', () {
      test('should create instance with all parameters', () {
        final profile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Software Developer',
          profileImageUrl: 'https://example.com/profile.jpg',
          bannerImageUrl: 'https://example.com/banner.jpg',
          location: 'New York',
          website: 'https://johndoe.com',
        );

        final user = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
          profile: profile,
          followersCount: 100,
          isFollowing: true,
        );

        expect(user.id, equals(1));
        expect(user.username, equals('johndoe'));
        expect(user.email, equals('john@example.com'));
        expect(user.profile, equals(profile));
        expect(user.followersCount, equals(100));
        expect(user.isFollowing, equals(true));
      });

      test('should create instance with default isFollowing value', () {
        final user = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
        );

        expect(user.isFollowing, equals(false));
      });

      test('should create instance with all null fields', () {
        final user = UserToFollowDto();

        expect(user.id, isNull);
        expect(user.username, isNull);
        expect(user.email, isNull);
        expect(user.profile, isNull);
        expect(user.followersCount, isNull);
        expect(user.isFollowing, equals(false));
      });

      test('should create instance with partial parameters', () {
        final user = UserToFollowDto(
          id: 2,
          username: 'janedoe',
        );

        expect(user.id, equals(2));
        expect(user.username, equals('janedoe'));
        expect(user.email, isNull);
        expect(user.profile, isNull);
        expect(user.followersCount, isNull);
      });
    });

    group('fromJson factory', () {
      test('should create instance from complete JSON', () {
        final json = <String, dynamic>{
          'id': 1,
          'username': 'johndoe',
          'email': 'john@example.com',
          'profile': <String, dynamic>{
            'name': 'John Doe',
            'bio': 'Software Developer',
            'profileImageUrl': 'https://example.com/profile.jpg',
            'bannerImageUrl': 'https://example.com/banner.jpg',
            'location': 'New York',
            'website': 'https://johndoe.com',
          },
          'followersCount': 100,
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.id, equals(1));
        expect(user.username, equals('johndoe'));
        expect(user.email, equals('john@example.com'));
        expect(user.profile, isNotNull);
        expect(user.profile!.name, equals('John Doe'));
        expect(user.profile!.bio, equals('Software Developer'));
        expect(user.profile!.profileImageUrl,
            equals('https://example.com/profile.jpg'));
        expect(user.profile!.bannerImageUrl,
            equals('https://example.com/banner.jpg'));
        expect(user.profile!.location, equals('New York'));
        expect(user.profile!.website, equals('https://johndoe.com'));
        expect(user.followersCount, equals(100));
      });

      test('should create instance from JSON with null profile', () {
        final json = <String, dynamic>{
          'id': 1,
          'username': 'johndoe',
          'email': 'john@example.com',
          'profile': null,
          'followersCount': 50,
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.id, equals(1));
        expect(user.username, equals('johndoe'));
        expect(user.email, equals('john@example.com'));
        expect(user.profile, isNull);
        expect(user.followersCount, equals(50));
      });

      test('should create instance from JSON with missing fields', () {
        final json = <String, dynamic>{
          'id': 2,
          'username': 'janedoe',
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.id, equals(2));
        expect(user.username, equals('janedoe'));
        expect(user.email, isNull);
        expect(user.profile, isNull);
        expect(user.followersCount, isNull);
      });

      test('should create instance from empty JSON', () {
        final json = <String, dynamic>{};

        final user = UserToFollowDto.fromJson(json);

        expect(user.id, isNull);
        expect(user.username, isNull);
        expect(user.email, isNull);
        expect(user.profile, isNull);
        expect(user.followersCount, isNull);
      });

      test('should handle profile with partial fields', () {
        final json = <String, dynamic>{
          'id': 1,
          'username': 'johndoe',
          'profile': <String, dynamic>{
            'name': 'John Doe',
            'bio': 'Developer',
          },
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.profile, isNotNull);
        expect(user.profile!.name, equals('John Doe'));
        expect(user.profile!.bio, equals('Developer'));
        expect(user.profile!.profileImageUrl, isNull);
        expect(user.profile!.bannerImageUrl, isNull);
        expect(user.profile!.location, isNull);
        expect(user.profile!.website, isNull);
      });

      test('should handle profile with all null fields', () {
        final json = <String, dynamic>{
          'id': 1,
          'username': 'johndoe',
          'profile': <String, dynamic>{
            'name': null,
            'bio': null,
            'profileImageUrl': null,
            'bannerImageUrl': null,
            'location': null,
            'website': null,
          },
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.profile, isNotNull);
        expect(user.profile!.name, isNull);
        expect(user.profile!.bio, isNull);
        expect(user.profile!.profileImageUrl, isNull);
        expect(user.profile!.bannerImageUrl, isNull);
        expect(user.profile!.location, isNull);
        expect(user.profile!.website, isNull);
      });

      test('should handle special characters in string fields', () {
        final json = <String, dynamic>{
          'id': 1,
          'username': 'user@name#123',
          'email': 'user+tag@example.com',
          'profile': <String, dynamic>{
            'name': 'John "The Dev" Doe',
            'bio': 'Love coding & design! 🚀',
            'location': 'New York, NY (USA)',
            'website': 'https://example.com?ref=twitter&utm_source=bio',
          },
          'followersCount': 999,
        };

        final user = UserToFollowDto.fromJson(json);

        expect(user.username, equals('user@name#123'));
        expect(user.email, equals('user+tag@example.com'));
        expect(user.profile!.name, equals('John "The Dev" Doe'));
        expect(user.profile!.bio, contains('Love coding & design! 🚀'));
        expect(user.profile!.location, equals('New York, NY (USA)'));
        expect(user.profile!.website,
            contains('https://example.com?ref=twitter&utm_source=bio'));
      });

      test('should handle zero and negative follower counts', () {
        final jsonZero = <String, dynamic>{
          'id': 1,
          'followersCount': 0,
        };

        final userZero = UserToFollowDto.fromJson(jsonZero);
        expect(userZero.followersCount, equals(0));

        final jsonNegative = <String, dynamic>{
          'id': 2,
          'followersCount': -5,
        };

        final userNegative = UserToFollowDto.fromJson(jsonNegative);
        expect(userNegative.followersCount, equals(-5));
      });
    });

    group('copyWith', () {
      test('should copy all fields', () {
        final originalProfile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          profileImageUrl: 'https://example.com/old.jpg',
          bannerImageUrl: 'https://example.com/banner.jpg',
          location: 'New York',
          website: 'https://johndoe.com',
        );

        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
          profile: originalProfile,
          followersCount: 100,
          isFollowing: false,
        );

        final newProfile = UserToFollowProfile(
          name: 'John Smith',
          bio: 'Senior Developer',
          profileImageUrl: 'https://example.com/new.jpg',
          bannerImageUrl: 'https://example.com/new-banner.jpg',
          location: 'San Francisco',
          website: 'https://johnsmith.com',
        );

        final copied = original.copyWith(
          id: 2,
          username: 'johnsmith',
          email: 'smith@example.com',
          profile: newProfile,
          followersCount: 500,
          isFollowing: true,
        );

        expect(copied.id, equals(2));
        expect(copied.username, equals('johnsmith'));
        expect(copied.email, equals('smith@example.com'));
        expect(copied.profile, equals(newProfile));
        expect(copied.followersCount, equals(500));
        expect(copied.isFollowing, equals(true));
      });

      test('should preserve original fields when not specified', () {
        final profile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
          profile: profile,
          followersCount: 100,
          isFollowing: false,
        );

        final copied = original.copyWith(followersCount: 200);

        expect(copied.id, equals(original.id));
        expect(copied.username, equals(original.username));
        expect(copied.email, equals(original.email));
        expect(copied.profile, equals(original.profile));
        expect(copied.followersCount, equals(200));
        expect(copied.isFollowing, equals(original.isFollowing));
      });

      test('should update isFollowing independently', () {
        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
          followersCount: 100,
          isFollowing: false,
        );

        final copied = original.copyWith(isFollowing: true);

        expect(copied.isFollowing, equals(true));
        expect(copied.id, equals(original.id));
        expect(copied.username, equals(original.username));
      });

      test('should update null fields to non-null', () {
        final original = UserToFollowDto(
          id: 1,
          username: null,
          email: null,
        );

        final copied = original.copyWith(
          username: 'johndoe',
          email: 'john@example.com',
        );

        expect(copied.username, equals('johndoe'));
        expect(copied.email, equals('john@example.com'));
        expect(copied.id, equals(1));
      });

      test('should update profile to new profile', () {
        final profile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
        );

        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          profile: profile,
        );

        final newProfile = UserToFollowProfile(
          name: 'Jane Smith',
          bio: 'Designer',
        );

        final copied = original.copyWith(profile: newProfile);

        expect(copied.profile, equals(newProfile));
        expect(copied.profile!.name, equals('Jane Smith'));
        expect(copied.id, equals(original.id));
        expect(copied.username, equals(original.username));
      });

      test('should copy with empty parameters', () {
        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          followersCount: 100,
        );

        final copied = original.copyWith();

        expect(copied.id, equals(original.id));
        expect(copied.username, equals(original.username));
        expect(copied.followersCount, equals(original.followersCount));
      });

      test('should update multiple fields in single call', () {
        final original = UserToFollowDto(
          id: 1,
          username: 'johndoe',
          email: 'john@example.com',
          followersCount: 50,
          isFollowing: false,
        );

        final copied = original.copyWith(
          email: 'newemail@example.com',
          followersCount: 150,
          isFollowing: true,
        );

        expect(copied.id, equals(1));
        expect(copied.username, equals('johndoe'));
        expect(copied.email, equals('newemail@example.com'));
        expect(copied.followersCount, equals(150));
        expect(copied.isFollowing, equals(true));
      });
    });
  });

  group('UserToFollowProfile', () {
    group('Constructor', () {
      test('should create instance with all parameters', () {
        final profile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Software Developer',
          profileImageUrl: 'https://example.com/profile.jpg',
          bannerImageUrl: 'https://example.com/banner.jpg',
          location: 'New York',
          website: 'https://johndoe.com',
        );

        expect(profile.name, equals('John Doe'));
        expect(profile.bio, equals('Software Developer'));
        expect(profile.profileImageUrl, equals('https://example.com/profile.jpg'));
        expect(profile.bannerImageUrl, equals('https://example.com/banner.jpg'));
        expect(profile.location, equals('New York'));
        expect(profile.website, equals('https://johndoe.com'));
      });

      test('should create instance with all null fields', () {
        final profile = UserToFollowProfile();

        expect(profile.name, isNull);
        expect(profile.bio, isNull);
        expect(profile.profileImageUrl, isNull);
        expect(profile.bannerImageUrl, isNull);
        expect(profile.location, isNull);
        expect(profile.website, isNull);
      });

      test('should create instance with partial parameters', () {
        final profile = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
        );

        expect(profile.name, equals('John Doe'));
        expect(profile.bio, equals('Developer'));
        expect(profile.profileImageUrl, isNull);
        expect(profile.bannerImageUrl, isNull);
        expect(profile.location, isNull);
        expect(profile.website, isNull);
      });
    });

    group('copyWith', () {
      test('should copy all fields', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          profileImageUrl: 'https://example.com/old.jpg',
          bannerImageUrl: 'https://example.com/banner.jpg',
          location: 'New York',
          website: 'https://johndoe.com',
        );

        final copied = original.copyWith(
          name: 'John Smith',
          bio: 'Senior Developer',
          profileImageUrl: 'https://example.com/new.jpg',
          bannerImageUrl: 'https://example.com/new-banner.jpg',
          location: 'San Francisco',
          website: 'https://johnsmith.com',
        );

        expect(copied.name, equals('John Smith'));
        expect(copied.bio, equals('Senior Developer'));
        expect(copied.profileImageUrl, equals('https://example.com/new.jpg'));
        expect(copied.bannerImageUrl, equals('https://example.com/new-banner.jpg'));
        expect(copied.location, equals('San Francisco'));
        expect(copied.website, equals('https://johnsmith.com'));
      });

      test('should preserve original fields when not specified', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          profileImageUrl: 'https://example.com/profile.jpg',
          location: 'New York',
        );

        final copied = original.copyWith(bio: 'Senior Developer');

        expect(copied.name, equals('John Doe'));
        expect(copied.bio, equals('Senior Developer'));
        expect(copied.profileImageUrl, equals('https://example.com/profile.jpg'));
        expect(copied.location, equals('New York'));
        expect(copied.bannerImageUrl, isNull);
        expect(copied.website, isNull);
      });

      test('should update fields to new values', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final copied = original.copyWith(
          bio: 'Senior Developer',
          profileImageUrl: 'https://example.com/new-profile.jpg',
        );

        expect(copied.name, equals('John Doe'));
        expect(copied.bio, equals('Senior Developer'));
        expect(copied.profileImageUrl,
            equals('https://example.com/new-profile.jpg'));
      });

      test('should copy with empty parameters', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
        );

        final copied = original.copyWith();

        expect(copied.name, equals(original.name));
        expect(copied.bio, equals(original.bio));
      });

      test('should update multiple fields in single call', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
          location: 'New York',
          website: 'https://johndoe.com',
        );

        final copied = original.copyWith(
          name: 'Jane Smith',
          location: 'San Francisco',
        );

        expect(copied.name, equals('Jane Smith'));
        expect(copied.bio, equals('Developer'));
        expect(copied.location, equals('San Francisco'));
        expect(copied.website, equals('https://johndoe.com'));
      });

      test('should handle empty string values', () {
        final original = UserToFollowProfile(
          name: 'John Doe',
          bio: 'Developer',
        );

        final copied = original.copyWith(
          name: '',
          bio: '',
        );

        expect(copied.name, equals(''));
        expect(copied.bio, equals(''));
      });

      test('should handle URL fields with special characters', () {
        final original = UserToFollowProfile(
          profileImageUrl: 'https://example.com/image.jpg',
          website: 'https://example.com',
        );

        final copied = original.copyWith(
          profileImageUrl: 'https://example.com/image?size=large&format=webp',
          website: 'https://example.com/profile?id=123&lang=en',
        );

        expect(copied.profileImageUrl,
            equals('https://example.com/image?size=large&format=webp'));
        expect(
            copied.website, equals('https://example.com/profile?id=123&lang=en'));
      });
    });
  });
}
