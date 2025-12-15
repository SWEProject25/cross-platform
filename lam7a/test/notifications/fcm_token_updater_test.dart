import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/proveriders/fcm_token_updater.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/services/cloud_messaging_service.dart';
import 'package:mocktail/mocktail.dart';

/// ---- MOCK CLASSES ----
class MockCloudMessagingService extends Mock implements CloudMessagingService {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockNotificationsReceiver extends Mock
    implements NotificationsReceiver {}

class MockAuthentication extends Authentication {
  AuthState _state;

  MockAuthentication(this._state);

  @override
  AuthState build() => _state;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCloudMessagingService mockCloudMessagingService;
  late MockNotificationsRepository mockNotificationsRepository;
  late MockNotificationsReceiver mockNotificationsReceiver;
  late StreamController<String> tokenRefreshController;

  setUp(() {
    mockCloudMessagingService = MockCloudMessagingService();
    mockNotificationsRepository = MockNotificationsRepository();
    mockNotificationsReceiver = MockNotificationsReceiver();
    tokenRefreshController = StreamController<String>.broadcast();

    // Setup default behavior
    when(() => mockCloudMessagingService.onTokenRefresh)
        .thenAnswer((_) => tokenRefreshController.stream);
    when(() => mockCloudMessagingService.getToken())
        .thenAnswer((_) async => 'test-fcm-token');
    when(() => mockNotificationsReceiver.requestPermission())
        .thenAnswer((_) async => {});
    when(() => mockNotificationsRepository.setFCMToken(any()))
        .thenAnswer((_) async => {});
    when(() => mockNotificationsRepository.removeFCMToken())
        .thenAnswer((_) async => {});
  });

  tearDown(() {
    tokenRefreshController.close();
  });

  UserModel createMockUser() => UserModel(
        id: 1,
        username: 'user',
        email: 'user@test.com',
        role: 'user',
        name: 'User',
        birthDate: '1990-01-01',
        profileImageUrl: '',
        bannerImageUrl: '',
        bio: '',
        location: '',
        website: '',
        createdAt: '2025-01-01',
      );

  group('FCMTokenUpdater', () {
    test('removes FCM token when no user is logged in', () async {
      // Arrange
      final mockAuth = MockAuthentication(
        AuthState(user: null, isAuthenticated: false),
      );

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(() => mockAuth),
          cloudMessagingServiceProvider
              .overrideWithValue(mockCloudMessagingService),
          notificationsRepositoryProvider
              .overrideWithValue(mockNotificationsRepository),
          notificationsReceiverProvider
              .overrideWithValue(mockNotificationsReceiver),
        ],
      );

      // Act
      container.read(fCMTokenUpdaterProvider);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(() => mockNotificationsRepository.removeFCMToken()).called(1);
      verifyNever(() => mockNotificationsReceiver.requestPermission());
      verifyNever(() => mockCloudMessagingService.getToken());
      verifyNever(() => mockNotificationsRepository.setFCMToken(any()));

      container.dispose();
    });

    test('sets FCM token when user is logged in', () async {
      // Arrange
      final user = createMockUser();
      final mockAuth = MockAuthentication(
        AuthState(user: user, isAuthenticated: true),
      );

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(() => mockAuth),
          cloudMessagingServiceProvider
              .overrideWithValue(mockCloudMessagingService),
          notificationsRepositoryProvider
              .overrideWithValue(mockNotificationsRepository),
          notificationsReceiverProvider
              .overrideWithValue(mockNotificationsReceiver),
        ],
      );

      // Act
      container.read(fCMTokenUpdaterProvider);
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(() => mockNotificationsReceiver.requestPermission()).called(1);
      verify(() => mockCloudMessagingService.getToken()).called(1);
      verify(() => mockNotificationsRepository.setFCMToken('test-fcm-token'))
          .called(1);
      verifyNever(() => mockNotificationsRepository.removeFCMToken());

      container.dispose();
    });
  });
}
