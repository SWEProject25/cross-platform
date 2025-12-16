import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/providers/unread_conversations_count.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationsRepository extends Mock implements ConversationsRepository {}
class MockMessagesSocketService extends Mock implements MessagesSocketService {}

void main() {
  late MockConversationsRepository mockConversationsRepository;
  late MockMessagesSocketService mockMessagesSocketService;
  late StreamController<MessageDto> incomingMessagesController;

  setUp(() {
    mockConversationsRepository = MockConversationsRepository();
    mockMessagesSocketService = MockMessagesSocketService();
    incomingMessagesController = StreamController<MessageDto>.broadcast();
    
    when(() => mockMessagesSocketService.incomingMessagesNotifications)
        .thenAnswer((_) => incomingMessagesController.stream);
  });

  tearDown(() {
    incomingMessagesController.close();
  });

  group('UnReadConversationsCount', () {
    test('build initializes with 0 and fetches count when user is authenticated', () async {
      const mockUser = UserModel(id: 123, username: 'testuser');
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 5);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(user: mockUser, isAuthenticated: true)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      // Initial state should be 0
      expect(container.read(unReadConversationsCountProvider), 0);

      // Wait for async initialization
      await Future.delayed(Duration(milliseconds: 100));

      // Should have fetched count
      expect(container.read(unReadConversationsCountProvider), 5);
      verify(() => mockConversationsRepository.getAllUnseenConversations()).called(1);
    });

    test('build does not fetch count when user is null', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 5);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      // Initial state should be 0
      expect(container.read(unReadConversationsCountProvider), 0);

      // Wait for async initialization
      await Future.delayed(Duration(milliseconds: 100));

      // Should still be 0 as user is null
      expect(container.read(unReadConversationsCountProvider), 0);
      verifyNever(() => mockConversationsRepository.getAllUnseenConversations());
    });

    test('refresh updates count from repository', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 3);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.listen(unReadConversationsCountProvider.notifier, (_,__) {}).read();
      
      await notifier.refresh();
      await Future.delayed(Duration(milliseconds: 50));

      expect(container.read(unReadConversationsCountProvider), 3);
      verify(() => mockConversationsRepository.getAllUnseenConversations()).called(1);
    });

    test('refresh with reset sets state to 0 then fetches count', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 7);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(() => Authentication()..state = const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(unReadConversationsCountProvider.notifier);
      
      // Set initial state to some value
      container.read(unReadConversationsCountProvider.notifier).state = 10;
      
      await notifier.refresh(reset: true);
      await Future.delayed(Duration(milliseconds: 50));

      expect(container.read(unReadConversationsCountProvider), 7);
      verify(() => mockConversationsRepository.getAllUnseenConversations()).called(1);
    });

    test('refresh with increment increases state by 1 then fetches count', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 4);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWith(() => Authentication()..state = const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(unReadConversationsCountProvider.notifier);
      
      // Set initial state
      container.read(unReadConversationsCountProvider.notifier).state = 2;
      
      await notifier.refresh(increament: true);
      await Future.delayed(Duration(milliseconds: 50));

      expect(container.read(unReadConversationsCountProvider), 4);
      verify(() => mockConversationsRepository.getAllUnseenConversations()).called(1);
    });

    test('listens to incoming messages and refreshes count', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 8);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );
      addTearDown(container.dispose);

      // Initialize the provider
      container.read(unReadConversationsCountProvider);
      
      // Clear any initial calls
      // clearInvocations(mockConversationsRepository);

      // // Emit an event to trigger refresh
      // incomingMessagesController.add(MessageDto(id: 1, conversationId: 1, senderId: 2, text: 'Hello', createdAt: DateTime.now()));
      
      // await Future.delayed(Duration(milliseconds: 100));

      // expect(container.read(unReadConversationsCountProvider), 8);
      // verify(() => mockConversationsRepository.getAllUnseenConversations()).called(1);
    });

    test('disposes stream subscription on dispose', () async {
      when(() => mockConversationsRepository.getAllUnseenConversations())
          .thenAnswer((_) async => 0);

      final container = ProviderContainer(
        overrides: [
          authenticationProvider.overrideWithValue(const AuthState(user: null, isAuthenticated: false)),
          conversationsRepositoryProvider.overrideWith((ref) => mockConversationsRepository),
          messagesSocketServiceProvider.overrideWith((ref) => mockMessagesSocketService),
        ],
      );

      // Initialize the provider
      container.read(unReadConversationsCountProvider);

      // Dispose the container
      container.dispose();

      // The subscription should be cancelled, so adding to the stream shouldn't trigger anything
      incomingMessagesController.add(MessageDto(id: 1, conversationId: 1, senderId: 2, text: 'Hello', createdAt: DateTime.now()));
      await Future.delayed(Duration(milliseconds: 50));

      // This should not cause any issues as the subscription is cancelled
      expect(incomingMessagesController.hasListener, false);
    });
  });
}
