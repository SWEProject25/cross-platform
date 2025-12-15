import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/models/user_dto.dart';

// A small fake ApiService that returns preset responses for get/post
class FakeApiService extends ApiService {
  final dynamic getResponse;
  final dynamic postResponse;
  final Exception? getException;
  final Exception? postException;

  FakeApiService({
    this.getResponse,
    this.postResponse,
    this.getException,
    this.postException,
  });

  @override
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    if (getException != null) throw getException!;
    return getResponse as T;
  }

  @override
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    if (postException != null) throw postException!;
    return postResponse as T;
  }
}

void main() {
  group('Authentication Provider', () {
    late Map<String, dynamic> dtoJson;

    setUp(() {
      dtoJson = {
        'id': 1,
        'user_id': 10,
        'name': 'Test User',
        'birth_date': null,
        'profile_image_url': 'https://example.com/avatar.jpg',
        'banner_image_url': '',
        'bio': '',
        'location': '',
        'website': '',
        'is_deactivated': false,
        'created_at': '2020-01-01T00:00:00Z',
        'updated_at': '2020-01-01T00:00:00Z',
        'User': {
          'id': 10,
          'username': 'testuser',
          'email': 'a@b.com',
          'role': 'user',
          'created_at': '2020-01-01T00:00:00Z'
        },
        'followers_count': 5,
        'following_count': 3,
        'is_followed_by_me': false,
      };
    });

    group('isAuthenticated - Success Path', () {
      test('isAuthenticated sets state when API returns data', () async {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
        expect(state.user, isNotNull);
        expect(state.user!.username, equals('testuser'));
        expect(state.user!.followersCount, equals(5));
        expect(state.user!.followingCount, equals(3));
      });

      test('isAuthenticated sets user email correctly', () async {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.user!.email, equals('a@b.com'));
      });

      test('isAuthenticated sets user name correctly', () async {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.user!.name, equals('Test User'));
      });
    });

    group('isAuthenticated - Error Path', () {
      test('isAuthenticated catches exception when API fails', () async {
        final fakeApi = FakeApiService(
          getException: Exception('Network error'),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        // Should not throw, exception is caught
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
      });

      test('isAuthenticated handles null response data', () async {
        final fakeApi = FakeApiService(getResponse: {'data': null});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
      });

      test('isAuthenticated handles missing data key', () async {
        final fakeApi = FakeApiService(getResponse: {});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
      });

      test('isAuthenticated handles DIO exception', () async {
        final fakeApi = FakeApiService(
          getException: DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Connection timeout',
          ),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        await notifier.isAuthenticated();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
      });
    });

    group('userDtoToUserModel Mapping', () {
      test('userDtoToUserModel maps values correctly', () {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        final dto = UserDtoAuth.fromJson(dtoJson);
        final userModel = notifier.userDtoToUserModel(dto);

        expect(userModel.username, equals('testuser'));
        expect(userModel.name, equals('Test User'));
        expect(userModel.profileImageUrl, equals('https://example.com/avatar.jpg'));
        expect(userModel.followersCount, equals(5));
        expect(userModel.followingCount, equals(3));
      });

      test('userDtoToUserModel handles null User object', () {
        final dtoJsonNoUser = {
          'id': 1,
          'name': 'Test User',
          'profile_image_url': 'https://example.com/avatar.jpg',
          'followers_count': 5,
          'following_count': 3,
        };

        final fakeApi = FakeApiService(getResponse: {'data': dtoJsonNoUser});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJsonNoUser);
        final userModel = notifier.userDtoToUserModel(dto);

        expect(userModel.username, isNull);
        expect(userModel.email, isNull);
      });

      test('userDtoToUserModel handles null profileImageUrl', () {
        final dtoWithoutImage = {
          'id': 1,
          'name': 'Test User',
          'profile_image_url': null,
          'followers_count': 5,
          'following_count': 3,
          'User': {
            'id': 10,
            'username': 'testuser',
            'email': 'a@b.com',
          },
        };

        final fakeApi = FakeApiService(getResponse: {'data': dtoWithoutImage});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoWithoutImage);
        final userModel = notifier.userDtoToUserModel(dto);

        expect(userModel.profileImageUrl, isNull);
      });
    });

    group('authenticateUser', () {
      test('authenticateUser(null) does nothing', () {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        expect(container.read(authenticationProvider).isAuthenticated, isFalse);

        notifier.authenticateUser(null);

        expect(container.read(authenticationProvider).isAuthenticated, isFalse);
      });

      test('authenticateUser with valid DTO sets state', () {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);

        notifier.authenticateUser(dto);

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
        expect(state.user, isNotNull);
        expect(state.user!.username, equals('testuser'));
      });
    });

    group('logout - Success Path', () {
      test('logout removes token and updates state on success', () async {
        SharedPreferences.setMockInitialValues({'token': 'abc'});

        final fakeApi = FakeApiService(
            postResponse: {'message': 'Logout successful'});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);
        expect(container.read(authenticationProvider).isAuthenticated, isTrue);

        await notifier.logout();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('token'), isNull);
      });
    });

    group('logout - Error Paths', () {
      test('logout does not remove token when API reports failure', () async {
        SharedPreferences.setMockInitialValues({'token': 'abc'});

        final fakeApi = FakeApiService(
            postResponse: {'message': 'Something went wrong'});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);
        expect(container.read(authenticationProvider).isAuthenticated, isTrue);

        await notifier.logout();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
        expect(state.user, isNotNull);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('token'), equals('abc'));
      });

      test('logout catches exception from API call', () async {
        SharedPreferences.setMockInitialValues({'token': 'abc'});

        final fakeApi = FakeApiService(
          postException: Exception('Network error'),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        // Should not throw
        await notifier.logout();

        // State should remain authenticated
        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
      });

      test('logout catches DioException', () async {
        SharedPreferences.setMockInitialValues({'token': 'abc'});

        final fakeApi = FakeApiService(
          postException: DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Server error',
          ),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        await notifier.logout();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
      });

      test('logout handles missing message in response', () async {
        SharedPreferences.setMockInitialValues({'token': 'abc'});

        final fakeApi = FakeApiService(postResponse: {});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        await notifier.logout();

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isTrue);
      });
    });

    group('updateUser', () {
      test('updateUser updates the user in state', () {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        final updatedDto = UserDtoAuth.fromJson({
          ...dtoJson,
          'name': 'Updated User',
        });
        final updatedUser = notifier.userDtoToUserModel(updatedDto);

        notifier.updateUser(updatedUser);

        final state = container.read(authenticationProvider);
        expect(state.user!.name, equals('Updated User'));
      });
    });

    group('refreshUser - Success Path', () {
      test('refreshUser updates user from server', () async {
        final fakeApi = FakeApiService(getResponse: {'data': dtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);

        // First authenticate
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        // Then refresh
        await notifier.refreshUser();

        final state = container.read(authenticationProvider);
        expect(state.user, isNotNull);
        expect(state.user!.username, equals('testuser'));
      });

      test('refreshUser updates user with new data', () async {
        final updatedDtoJson = {
          ...dtoJson,
          'followers_count': 100,
          'following_count': 50,
        };

        final fakeApi = FakeApiService(getResponse: {'data': updatedDtoJson});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        await notifier.refreshUser();

        final state = container.read(authenticationProvider);
        expect(state.user!.followersCount, equals(100));
        expect(state.user!.followingCount, equals(50));
      });
    });

    group('refreshUser - Error Paths', () {
      test('refreshUser catches exception from API', () async {
        final fakeApi = FakeApiService(
          getException: Exception('Network error'),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        // Should not throw
        await notifier.refreshUser();

        // State should remain unchanged
        final state = container.read(authenticationProvider);
        expect(state.user, isNotNull);
        expect(state.user!.username, equals('testuser'));
      });

      test('refreshUser handles null response data', () async {
        final fakeApi = FakeApiService(getResponse: {'data': null});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        final userBefore = container.read(authenticationProvider).user;

        await notifier.refreshUser();

        final state = container.read(authenticationProvider);
        // User should remain unchanged
        expect(state.user, equals(userBefore));
      });

      test('refreshUser catches DioException', () async {
        final fakeApi = FakeApiService(
          getException: DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Server error',
          ),
        );
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        await notifier.refreshUser();

        final state = container.read(authenticationProvider);
        expect(state.user, isNotNull);
      });

      test('refreshUser handles missing data key', () async {
        final fakeApi = FakeApiService(getResponse: {});
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(fakeApi),
        ]);
        addTearDown(container.dispose);

        final notifier = container.read(authenticationProvider.notifier);
        final dto = UserDtoAuth.fromJson(dtoJson);
        notifier.authenticateUser(dto);

        await notifier.refreshUser();

        final state = container.read(authenticationProvider);
        expect(state.user, isNotNull);
      });
    });

    group('Initial State', () {
      test('provider initializes with default AuthState', () {
        final container = ProviderContainer(overrides: [
          apiServiceProvider.overrideWithValue(
            FakeApiService(getResponse: {'data': dtoJson}),
          ),
        ]);
        addTearDown(container.dispose);

        final state = container.read(authenticationProvider);
        expect(state.isAuthenticated, isFalse);
        expect(state.user, isNull);
        expect(state.token, isNull);
      });
    });
  });
}
