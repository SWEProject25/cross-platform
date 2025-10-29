import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service_impl.dart';
import 'package:lam7a/features/messaging/services/chats_api_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_api_service.g.dart';

@riverpod
Future<ChatsApiService> chatsApiService(Ref ref) async {
  final apiService = await ref.read(apiServiceProvider.future);
  return ChatsApiServiceImpl(apiService);
}


abstract class ChatsApiService {

  Future<ApiResponse<List<ConversationDto>>> getConversations();

  Future<List<Contact>> getContacts();

  Future<List<ChatMessage>> getMessages(String conversationId);
}