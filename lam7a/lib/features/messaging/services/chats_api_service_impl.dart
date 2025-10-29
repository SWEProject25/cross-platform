import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service.dart';


class ChatsApiServiceImpl extends ChatsApiService {
  ApiService _apiService;

  ChatsApiServiceImpl(this._apiService);

  Future<ApiResponse<List<ConversationDto>>> getConversations() async {
      var responseJson = await _apiService.get(endpoint: "/conversations");

      final response = ApiResponse<List<ConversationDto>>.fromJson(
        responseJson,
        (json) => (json as List)
            .map((item) => ConversationDto.fromJson(item))
            .toList(),
      );

      return response;
  }

  Future<List<Contact>> getContacts() {
    return Future.value([]);
  }

  Future<List<ChatMessage>> getMessages(String conversationId){
    return Future.value([]);
  }
}