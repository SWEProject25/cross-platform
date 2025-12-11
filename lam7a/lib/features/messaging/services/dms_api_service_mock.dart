// mock_dms_api_service.dart
import 'dart:async';
import 'dart:math';

import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';

class MockDMsApiService implements DMsApiService {
  final Duration latency;
  final int pageLimit;
  final Random _rand = Random();

  final List<Contact> _contacts = [];
  final List<ConversationDto> _conversations = [];
  final Map<int, List<MessageDto>> _messagesByConversation = {};

  int _nextConversationId = 1000;
  int _nextMessageId = 5000;

  /// Create and auto-generate dummy data immediately
  MockDMsApiService({this.latency = const Duration(milliseconds: 120), this.pageLimit = 20}) {
    _generateDummyData();
  }

  // -----------------------
  // Public helpers (optional)
  // -----------------------

  /// Add a message to a conversation (keeps stateful mock useful for UI tests)
  MessageDto addMessage(int conversationId, {required int senderId, required String text, DateTime? createdAt}) {
    final dto = MessageDto(
      id: _nextMessageId++,
      senderId: senderId,
      conversationId: conversationId,
      text: text,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: createdAt ?? DateTime.now(),
    );

    _messagesByConversation.putIfAbsent(conversationId, () => []);
    _messagesByConversation[conversationId]!.add(dto);

    // update conversation lastMessage and updatedAt if exists
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      _conversations[idx] = _conversations[idx].copyWith(lastMessage: dto, updatedAt: dto.updatedAt ?? DateTime.now());
    }

    return dto;
  }

  // -----------------------
  // Implementation
  // -----------------------

  @override
  Future<ApiResponse<List<ConversationDto>>> getConversations() async {
    await Future.delayed(latency);
    final sorted = List<ConversationDto>.from(_conversations)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Build metadata using your Metadata class if ApiResponse expects it:
    // Since your ApiResponse is a freezed generic with Metadata, construct it normally.
    final meta = Metadata(
      totalItems: sorted.length,
      page: 1,
      limit: sorted.length,
      totalPages: 1,
    );

    return ApiResponse<List<ConversationDto>>(
      status: 'success',
      data: sorted,
      metadata: meta,
    );
  }

  @override
  Future<int> createConversation(int userId) async {
    await Future.delayed(latency);
    final contact = _contacts.firstWhere((c) => c.id == userId, orElse: () {
      // If not found, create a minimal contact so the conversation can exist
      final newContact = Contact(
        id: userId,
        name: 'User $userId',
        handle: 'user$userId',
        avatarUrl: null,
        bio: null,
        totalFollowers: 0,
      );
      _contacts.add(newContact);
      return newContact;
    });

    final convId = _nextConversationId++;
    final conv = ConversationDto(
      id: convId,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now(),
      lastMessage: null,
      user: UserDto(
        id: contact.id,
        username: contact.handle,
        profileImageUrl: contact.avatarUrl,
        displayName: contact.name,
      ),
    );

    _conversations.add(conv);
    _messagesByConversation[convId] = [];
    return convId;
  }

  @override
  Future<MessagesResponseDto> getMessageHistory(int conversationId, int? lastMessageId) async {
    await Future.delayed(latency);
    final messages = _messagesByConversation[conversationId] ?? [];

    if (messages.isEmpty) {
      return MessagesResponseDto(
        status: 'success',
        data: <MessageDto>[],
        metadata: MessagesMetadataDto(totalItems: 0, limit: pageLimit, hasMore: false, lastMessageId: null),
      );
    }

    // messages are ordered by createdAt ascending in this mock
    // Pagination by lastMessageId: return up to pageLimit messages BEFORE the message with lastMessageId.
    List<MessageDto> page;
    if (lastMessageId == null) {
      final start = (messages.length - pageLimit).clamp(0, messages.length);
      page = messages.sublist(start);
    } else {
      final idx = messages.indexWhere((m) => m.id == lastMessageId);
      final end = idx == -1 ? messages.length : idx;
      final start = (end - pageLimit).clamp(0, end);
      page = messages.sublist(start, end);
    }

    final hasMore = messages.isNotEmpty && page.isNotEmpty && messages.first.id != page.first.id;
    final lastId = page.isNotEmpty ? page.first.id : null;

    final metadata = MessagesMetadataDto(
      totalItems: messages.length,
      limit: pageLimit,
      hasMore: hasMore,
      lastMessageId: lastId,
    );

    return MessagesResponseDto(status: 'success', data: page, metadata: metadata);
  }

  @override
  Future<List<Contact>> searchForContacts(String query, int page, [int limit = 20]) async {
    await Future.delayed(latency);
    final q = query.trim().toLowerCase();
    final matches = _contacts.where((c) => c.name.toLowerCase().contains(q) || c.handle.toLowerCase().contains(q)).toList();

    final start = (page - 1) * limit;
    if (start >= matches.length) return <Contact>[];

    final end = (start + limit) > matches.length ? matches.length : (start + limit);
    return matches.sublist(start, end);
  }

  @override
  Future<Contact> getContactByUserId(int userId) async {
    await Future.delayed(latency);
    final contact = _contacts.firstWhere((c) => c.id == userId, orElse: () => throw StateError('Contact not found for id $userId'));
    return contact;
  }

  // -----------------------
  // Private data generation
  // -----------------------

  void _generateDummyData() {
    final now = DateTime.now();
    final names = [
      'Alice Smith',
      'Bob Johnson',
      'Charlie King',
      'Dana Lee',
      'Eva Brown',
      'Frank Green',
      'Grace White',
      'Henry Black',
      'Isla Blue',
      'Jack Grey',
    ];

    // Contacts
    for (int i = 0; i < names.length; i++) {
      final name = names[i];
      _contacts.add(Contact(
        id: i + 1,
        name: name,
        handle: name.split(' ').first.toLowerCase(),
        avatarUrl: 'https://i.pravatar.cc/150?img=${(i % 70) + 1}',
        bio: 'This is ${name.split(' ').first}\'s bio.',
        totalFollowers: _rand.nextInt(5000),
      ));
    }

    // Conversations + messages
    for (int i = 0; i < 6; i++) {
      final contact = _contacts[_rand.nextInt(_contacts.length)];
      final convId = _nextConversationId++;
      final msgCount = 10 + _rand.nextInt(25);

      final messages = <MessageDto>[];
      for (int j = 0; j < msgCount; j++) {
        final isMe = j % 2 == 0;
        final senderId = isMe ? 0 : contact.id;
        final created = now.subtract(Duration(minutes: (msgCount - j) * 7));
        messages.add(MessageDto(
          id: _nextMessageId++,
          senderId: senderId,
          conversationId: convId,
          text: isMe ? 'Me: message #$j' : '${contact.name.split(' ').first}: reply #$j',
          createdAt: created,
          updatedAt: created,
        ));
      }

      _messagesByConversation[convId] = messages;

      final lastMsg = messages.isNotEmpty ? messages.last : null;
      _conversations.add(ConversationDto(
        id: convId,
        createdAt: now.subtract(Duration(days: _rand.nextInt(30))).toIso8601String(),
        updatedAt: lastMsg?.createdAt ?? now,
        lastMessage: lastMsg,
        user: UserDto(
          id: contact.id,
          username: contact.handle,
          profileImageUrl: contact.avatarUrl,
          displayName: contact.name,
        ),
      ));
    }
  }
  
  @override
  Future<int> getNumberOfUnseenConversations(int? conversationId) {
    return Future.value(_rand.nextInt(10));
  }
  
  @override
  Future<ConversationDto> getConversationById(int id) {
    // TODO: implement getConversationById
    throw UnimplementedError();
  }
  
  @override
  Future<MessagesResponseDto> getLostMessages(int conversationId, int? lastMessageId) {
    // TODO: implement getLostMessages
    throw UnimplementedError();
  }
}
