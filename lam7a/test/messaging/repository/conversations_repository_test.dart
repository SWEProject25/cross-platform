import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/adapters/conversation_adapter.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';

class MockDMsApiService extends Mock implements DMsApiService {}

class MockAuthenticationImplRepository extends Mock implements AuthenticationRepositoryImpl {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockBox<T> extends Mock implements Box<T> {}

class FakeAuthState extends Fake implements AuthState {
  @override
  final UserModel? user;

  @override
  final bool isAuthenticated;

  FakeAuthState({this.user, this.isAuthenticated = false});
}

void main() {
  late MockDMsApiService mockApiService;
  late MockAuthenticationImplRepository mockAuthRepo;
  late MockProfileRepository mockProfileRepo;
  late AuthState authState;
  late ConversationsRepository repository;
  late Directory tempDir;

  final testUser = UserModel(id: 1, username: 'testuser');

  final testConversationDto = ConversationDto(
    id: 1,
    createdAt: '2024-01-01',
    updatedAt: DateTime(2024, 1, 1),
    unseenCount: 0,
    user: UserDto(
      id: 2,
      username: 'otheruser',
      displayName: 'Other User',
      profileImageUrl: 'http://example.com/avatar.jpg',
    ),
    lastMessage: MessageDto(
      id: 1,
      text: 'Hello',
      createdAt: DateTime(2024, 1, 1),
      senderId: 2,
      conversationId: 1,
    ),
    isBlocked: false,
  );

  final testConversation = Conversation(
    id: 1,
    name: 'Other User',
    userId: 2,
    username: 'otheruser',
    avatarUrl: 'http://example.com/avatar.jpg',
    lastMessage: 'Hello',
    lastMessageTime: DateTime(2024, 1, 1),
    unseenCount: 0,
    isBlocked: false,
  );

  final testContact = Contact(
    id: 2,
    name: 'Other User',
    handle: '@otheruser',
    avatarUrl: 'http://example.com/avatar.jpg',
  );

  final testFollowerUser = UserModel(
    id: 2,
    username: 'otheruser',
    name: 'Other User',
    profileImageUrl: 'http://example.com/avatar.jpg',
  );

  final testAuthUser = UserToFollowDto(
    id: 2,
    username: 'otheruser',
    profile: UserToFollowProfile(
      name: 'Other User',
      profileImageUrl: 'http://example.com/avatar.jpg',
    ),
  );

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    Hive.registerAdapter(ConversationAdapter());
  });

  setUp(() {
    mockApiService = MockDMsApiService();
    mockAuthRepo = MockAuthenticationImplRepository();
    mockProfileRepo = MockProfileRepository();
    authState = FakeAuthState(user: testUser, isAuthenticated: true);
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  group('ConversationsRepository Tests', () {
    test('fetchConversations returns empty when not authenticated', () async {
      authState = FakeAuthState(isAuthenticated: false);
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      final result = await repository.fetchConversations();

      expect(result.$1, isEmpty);
      expect(result.$2, false);
      verifyNever(() => mockApiService.getConversations());
    });

    test('fetchConversations fetches and caches conversations successfully', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.getConversations()).thenAnswer(
        (_) async => ApiResponse<List<ConversationDto>>(
          status: 'success',
          data: [testConversationDto],
          metadata: Metadata(totalItems: 1, page: 1, limit: 20, totalPages: 1),
        ),
      );

      final result = await repository.fetchConversations();

      expect(result.$1.length, 1);
      expect(result.$1.first.id, testConversation.id);
      expect(result.$1.first.name, testConversation.name);
      expect(result.$2, false); // page == totalPages
      verify(() => mockApiService.getConversations()).called(1);
    });

    test('fetchConversations indicates hasMore when more pages available', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.getConversations()).thenAnswer(
        (_) async => ApiResponse<List<ConversationDto>>(
          status: 'success',
          data: [testConversationDto],
          metadata: Metadata(totalItems: 40, page: 1, limit: 20, totalPages: 2),
        ),
      );

      final result = await repository.fetchConversations();

      expect(result.$2, true); // page != totalPages
    });

    test('fetchConversations falls back to Hive on API error', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      // Pre-populate Hive
      var box = await Hive.openBox<Conversation>('conversations');
      await box.put(1, testConversation);

      when(() => mockApiService.getConversations()).thenThrow(Exception('Network error'));

      final result = await repository.fetchConversations();

      expect(result.$1.length, 1);
      expect(result.$1.first.id, testConversation.id);
      expect(result.$2, false);

      await box.clear();
      await box.close();
    });

    test('fetchConversations sorts cached conversations by lastMessageTime', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      final oldConv = testConversation.copyWith(id: 2, lastMessageTime: DateTime(2024, 1, 1));
      final newConv = testConversation.copyWith(id: 3, lastMessageTime: DateTime(2024, 1, 2));

      var box = await Hive.openBox<Conversation>('conversations');
      await box.put(2, oldConv);
      await box.put(3, newConv);

      when(() => mockApiService.getConversations()).thenThrow(Exception('Network error'));

      final result = await repository.fetchConversations();

      expect(result.$1.first.id, 3); // Newer conversation first
      expect(result.$1.last.id, 2);

      await box.clear();
      await box.close();
    });

    test('getConversationById returns conversation', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.getConversationById(1)).thenAnswer((_) async => testConversationDto);

      final result = await repository.getConversationById(1);

      expect(result.id, testConversation.id);
      expect(result.name, testConversation.name);
      verify(() => mockApiService.getConversationById(1)).called(1);
    });

    test('getConversationIdByUserId returns conversation id', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.createConversation(2)).thenAnswer((_) async => 1);

      final result = await repository.getConversationIdByUserId(2);

      expect(result, 1);
      verify(() => mockApiService.createConversation(2)).called(1);
    });

    test('searchForContacts with short query and not authenticated returns empty', () async {
      authState = FakeAuthState(isAuthenticated: false);
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      final result = await repository.searchForContacts('a', 1);

      expect(result, isEmpty);
      verifyNever(() => mockApiService.searchForContacts(any(), any(), any()));
    });

    test('searchForContacts with short query returns followers, following, and suggested', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockProfileRepo.getFollowers(1)).thenAnswer((_) async => [testFollowerUser]);
      when(() => mockProfileRepo.getFollowing(1)).thenAnswer((_) async => [testFollowerUser.copyWith(id: 3)]);
      when(() => mockAuthRepo.getUsersToFollow(50)).thenAnswer((_) async => [testAuthUser]);

      final result = await repository.searchForContacts('a', 1);

      expect(result.length, 2); // 2 unique contacts (id 2 and 3)
      verify(() => mockProfileRepo.getFollowers(1)).called(1);
      verify(() => mockProfileRepo.getFollowing(1)).called(1);
      verify(() => mockAuthRepo.getUsersToFollow(50)).called(1);
    });

    test('searchForContacts with empty query returns all contacts', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockProfileRepo.getFollowers(1)).thenAnswer((_) async => [testFollowerUser]);
      when(() => mockProfileRepo.getFollowing(1)).thenAnswer((_) async => []);
      when(() => mockAuthRepo.getUsersToFollow(50)).thenAnswer((_) async => []);

      final result = await repository.searchForContacts('', 1);

      expect(result.length, 1);
      verifyNever(() => mockApiService.searchForContacts(any(), any(), any()));
    });

    test('searchForContacts with long query calls API', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.searchForContacts('search', 1, 20)).thenAnswer((_) async => [testContact]);

      final result = await repository.searchForContacts('search', 1);

      expect(result.length, 1);
      expect(result.first.id, testContact.id);
      verify(() => mockApiService.searchForContacts('search', 1, 20)).called(1);
      verifyNever(() => mockProfileRepo.getFollowers(any()));
    });

    test('searchForContacts with custom limit', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.searchForContacts('search', 1, 50)).thenAnswer((_) async => [testContact]);

      final result = await repository.searchForContacts('search', 1, 50);

      expect(result.length, 1);
      verify(() => mockApiService.searchForContacts('search', 1, 50)).called(1);
    });

    test('searchForContacts removes duplicate contacts', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      final duplicateProfile = testFollowerUser.copyWith(name: 'Updated Name');

      when(() => mockProfileRepo.getFollowers(1)).thenAnswer((_) async => [testFollowerUser]);
      when(() => mockProfileRepo.getFollowing(1)).thenAnswer((_) async => [duplicateProfile]); // Same id, different name
      when(() => mockAuthRepo.getUsersToFollow(50)).thenAnswer((_) async => []);

      final result = await repository.searchForContacts('', 1);

      expect(result.length, 1); // Only one contact despite duplicate id
      expect(result.first.name, 'Updated Name'); // Later one overwrites
    });

    test('getContactByUserId returns contact', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.getContactByUserId(2)).thenAnswer((_) async => testContact);

      final result = await repository.getContactByUserId(2);

      expect(result.id, testContact.id);
      expect(result.name, testContact.name);
      verify(() => mockApiService.getContactByUserId(2)).called(1);
    });

    test('getAllUnseenConversations returns count', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      when(() => mockApiService.getNumberOfUnseenConversations(null)).thenAnswer((_) async => 5);

      final result = await repository.getAllUnseenConversations();

      expect(result, 5);
      verify(() => mockApiService.getNumberOfUnseenConversations(null)).called(1);
    });

    test('fetchConversations handles conversations without lastMessageTime', () async {
      repository = ConversationsRepository(mockApiService, authState, mockAuthRepo, mockProfileRepo);

      final convWithoutTime = testConversation.copyWith(id: 2, lastMessageTime: null);
      final convWithTime = testConversation.copyWith(id: 3, lastMessageTime: DateTime(2024, 1, 2));

      var box = await Hive.openBox<Conversation>('conversations');
      await box.put(2, convWithoutTime);
      await box.put(3, convWithTime);

      when(() => mockApiService.getConversations()).thenThrow(Exception('Network error'));

      final result = await repository.fetchConversations();

      expect(result.$1.first.id, 3); // Conversation with time comes first
      expect(result.$1.last.id, 2); // Conversation without time comes last

      await box.clear();
      await box.close();
    });
  });
}
