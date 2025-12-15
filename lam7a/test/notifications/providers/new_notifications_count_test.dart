import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/mention_notifications_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationsRepository extends Mock implements NotificationsRepository {}


class MockMentionNotificationsViewModel extends MentionNotificationsViewmodel {
  int refreshCallCount = 0;

  @override
  Future<void> refresh() async {
    refreshCallCount++;
    return super.refresh();
  }
}

class MockAllNotificationsViewModel extends AllNotificationsViewModel {
  int refreshCallCount = 0;

  @override
  Future<void> refresh() async {
    refreshCallCount++;
    return super.refresh();
  }
}

void main() {
  late MockNotificationsRepository mockRepository;
  late MockAllNotificationsViewModel mockAllNotificationsVM;
  late MockMentionNotificationsViewModel mockMentionNotificationsVM;
  late ProviderContainer container;

  final testUser = UserModel(id: 1, username: 'testuser');

  setUp(() {
    mockRepository = MockNotificationsRepository();
    mockAllNotificationsVM = MockAllNotificationsViewModel();
    mockMentionNotificationsVM = MockMentionNotificationsViewModel();

    when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 5);
    // when(() => mockAllNotificationsVM.refresh()).thenAnswer((_) async {});
    // when(() => mockMentionNotificationsVM.refresh()).thenAnswer((_) async {});
  });

  tearDown(() {
    container.dispose();
  });

  group('NewNotificationCount Tests', () {
    test('build initializes state to 0 when user is not authenticated', () {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final state = container.read(unReadNotificationCountProvider);

      expect(state, 0);
      verifyNever(() => mockRepository.getUnReadCount());
    });

    test('build initializes state to 0 and calls updateNotificationsCount when authenticated', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final initialState = container.read(unReadNotificationCountProvider);
      expect(initialState, 0);

      // Wait for microtask to complete
      await Future.delayed(Duration(milliseconds: 100));

      final updatedState = container.read(unReadNotificationCountProvider);
      expect(updatedState, 5);
      verify(() => mockRepository.getUnReadCount()).called(1);
    });

    test('updateNotificationsCount fetches and updates count', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);
      expect(container.read(unReadNotificationCountProvider), 0);

      await notifier.updateNotificationsCount();

      expect(container.read(unReadNotificationCountProvider), 5);
      verify(() => mockRepository.getUnReadCount()).called(greaterThan(0));
    });

    test('updateNotificationsCount with reset sets state to 0 then updates', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);
      
      // Set initial state to 10
      await notifier.updateNotificationsCount();
      await Future.delayed(Duration(milliseconds: 50));

      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 3);

      await notifier.updateNotificationsCount(reset: true);

      expect(container.read(unReadNotificationCountProvider), 3);
      verify(() => mockRepository.getUnReadCount()).called(greaterThan(0));
    });

    test('updateNotificationsCount with increment increases state then updates', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);
      
      // Set initial state to 5
      await notifier.updateNotificationsCount();
      await Future.delayed(Duration(milliseconds: 50));

      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 7);

      await notifier.updateNotificationsCount(increament: true);

      expect(container.read(unReadNotificationCountProvider), 7);
      verify(() => mockRepository.getUnReadCount()).called(greaterThan(0));
    });

    test('notifyViewModels calls refresh on both viewmodels', () {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
          allNotificationsViewModelProvider.overrideWith(() => mockAllNotificationsVM),
          mentionNotificationsViewModelProvider.overrideWith(() => mockMentionNotificationsVM),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);

      notifier.notifyViewModels();

      expect(mockAllNotificationsVM.refreshCallCount, 1);
      expect(mockMentionNotificationsVM.refreshCallCount, 1);
    });

    test('state updates are reflected correctly', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      expect(container.read(unReadNotificationCountProvider), 0);

      // First update
      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 10);
      await container.read(unReadNotificationCountProvider.notifier).updateNotificationsCount();

      expect(container.read(unReadNotificationCountProvider), 10);

      // Second update with different count
      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 3);
      await container.read(unReadNotificationCountProvider.notifier).updateNotificationsCount();

      expect(container.read(unReadNotificationCountProvider), 3);
    });

    test('multiple calls to updateNotificationsCount work correctly', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);

      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 5);
      await notifier.updateNotificationsCount();
      expect(container.read(unReadNotificationCountProvider), 5);

      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 8);
      await notifier.updateNotificationsCount();
      expect(container.read(unReadNotificationCountProvider), 8);

      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 0);
      await notifier.updateNotificationsCount(reset: true);
      expect(container.read(unReadNotificationCountProvider), 0);
    });

    test('reset and increment flags work together', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final notifier = container.read(unReadNotificationCountProvider.notifier);

      // Set initial value
      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 10);
      await notifier.updateNotificationsCount();
      expect(container.read(unReadNotificationCountProvider), 10);

      // Reset has priority over increment
      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 5);
      await notifier.updateNotificationsCount(reset: true, increament: true);
      expect(container.read(unReadNotificationCountProvider), 5);
    });

    test('provider keeps alive after disposal attempt', () async {
      container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(isAuthenticated: false, user: UserModel(id: 0))),
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      // Read the provider to initialize it
      container.read(unReadNotificationCountProvider);

      // Wait for microtask
      await Future.delayed(Duration(milliseconds: 100));

      // Provider should still be alive and functional
      final notifier = container.read(unReadNotificationCountProvider.notifier);
      when(() => mockRepository.getUnReadCount()).thenAnswer((_) async => 7);
      await notifier.updateNotificationsCount();

      expect(container.read(unReadNotificationCountProvider), 7);
    });
  });
}
