import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service_impl.dart';
import 'package:lam7a/features/messaging/services/dms_api_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dms_api_service.g.dart';

@riverpod
DMsApiService dmsApiService(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return DMsApiServiceImpl(apiService);
}


abstract class DMsApiService {

  Future<ApiResponse<List<ConversationDto>>> getConversations();

  Future<List<Contact>> getContacts();

  Future<List<ChatMessage>> getMessages(String conversationId);

  Future<int> createConversation(int userId);

  Future<MessagesResponseDto> getMessageHistory(int conversationId, int? lastMessageId);
}