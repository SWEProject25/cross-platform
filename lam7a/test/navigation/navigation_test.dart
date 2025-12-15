import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';

void main() {
  group('Navigation Utils Models', () {
    group('Usermaindata', () {
      test('should create instance with all fields', () {
        final user = Usermaindata(
          name: 'John Doe',
          userName: 'johndoe',
          profileImageUrl: 'https://example.com/avatar.jpg',
        );

        expect(user.name, equals('John Doe'));
        expect(user.userName, equals('johndoe'));
        expect(user.profileImageUrl, equals('https://example.com/avatar.jpg'));
      });

      test('should create instance with null fields', () {
        final user = Usermaindata();

        expect(user.name, isNull);
        expect(user.userName, isNull);
        expect(user.profileImageUrl, isNull);
      });

      test('should create instance with partial fields', () {
        final user = Usermaindata(
          name: 'Jane Doe',
          userName: 'janedoe',
        );

        expect(user.name, equals('Jane Doe'));
        expect(user.userName, equals('janedoe'));
        expect(user.profileImageUrl, isNull);
      });

      test('should allow updating fields', () {
        final user = Usermaindata();
        
        user.name = 'Updated Name';
        user.userName = 'updatedusername';
        user.profileImageUrl = 'https://example.com/new-avatar.jpg';

        expect(user.name, equals('Updated Name'));
        expect(user.userName, equals('updatedusername'));
        expect(user.profileImageUrl, equals('https://example.com/new-avatar.jpg'));
      });

      test('should handle empty string values', () {
        final user = Usermaindata(
          name: '',
          userName: '',
          profileImageUrl: '',
        );

        expect(user.name, equals(''));
        expect(user.userName, equals(''));
        expect(user.profileImageUrl, equals(''));
      });

      test('should differentiate between null and empty string', () {
        final userWithNull = Usermaindata(name: null);
        final userWithEmpty = Usermaindata(name: '');

        expect(userWithNull.name, isNull);
        expect(userWithEmpty.name, isEmpty);
        expect(userWithNull.name != userWithEmpty.name, isTrue);
      });

      test('should handle special characters in username', () {
        final user = Usermaindata(userName: '@user_name-123');
        expect(user.userName, equals('@user_name-123'));
      });

      test('should handle long names', () {
        final longName = 'A' * 1000;
        final user = Usermaindata(name: longName);
        expect(user.name, equals(longName));
        expect(user.name!.length, equals(1000));
      });

      test('should handle URLs with special characters', () {
        final complexUrl = 'https://example.com/avatar/user%20space?size=large&quality=high';
        final user = Usermaindata(profileImageUrl: complexUrl);
        expect(user.profileImageUrl, equals(complexUrl));
      });

      test('should handle unicode characters', () {
        final user = Usermaindata(
          name: 'مستخدم',
          userName: '用户',
        );

        expect(user.name, equals('مستخدم'));
        expect(user.userName, equals('用户'));
      });

      test('should create multiple instances independently', () {
        final user1 = Usermaindata(name: 'User 1');
        final user2 = Usermaindata(name: 'User 2');

        expect(user1.name, equals('User 1'));
        expect(user2.name, equals('User 2'));
        expect(user1.name != user2.name, isTrue);
      });

      test('should preserve data when creating from another instance', () {
        final original = Usermaindata(
          name: 'Original',
          userName: 'original_user',
          profileImageUrl: 'https://example.com/avatar.jpg',
        );

        final copy = Usermaindata(
          name: original.name,
          userName: original.userName,
          profileImageUrl: original.profileImageUrl,
        );

        expect(copy.name, equals(original.name));
        expect(copy.userName, equals(original.userName));
        expect(copy.profileImageUrl, equals(original.profileImageUrl));
      });
    });
  });
}
