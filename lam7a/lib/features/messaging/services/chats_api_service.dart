import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_api_service.g.dart';

@riverpod
ChatsApiService chatsApiService(Ref ref) {
  return ChatsApiServiceMock();
}

abstract class ChatsApiService {
  Future<List<Conversation>> getConversations();

  Future<List<Contact>> getContacts();

  Future<List<ChatMessage>> getMessages(String conversationId);
}
