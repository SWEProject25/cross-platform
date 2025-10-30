import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';

class DMsApiServiceImpl extends DMsApiService {
  ApiService _apiService;

  DMsApiServiceImpl(this._apiService);

  Future<ApiResponse<List<ConversationDto>>> getConversations() async {
    var responseJson = await _apiService.get(endpoint: "/conversations");

    final response = ApiResponse<List<ConversationDto>>.fromJson(
      responseJson,
      (json) =>
          (json as List).map((item) => ConversationDto.fromJson(item)).toList(),
    );

    return response;
  }

  Future<List<Contact>> getContacts() {
    return Future.value([]);
  }

  Future<List<ChatMessage>> getMessages(String conversationId) {
    return Future.value([]);
  }

  Future<int> createConversation(int userId) async {
    var responseJson = await _apiService.post(endpoint: "/conversations");

    return int.tryParse(responseJson['data']['id']) ?? -1;
  }

  Future<MessagesResponseDto> getMessageHistory(
    int conversationId,
    int? lastMessageId,
  ) async {
    print("getMessageHistory $conversationId $lastMessageId");
    var response = await _apiService.get<MessagesResponseDto>(
      endpoint: "/messages/$conversationId",
      queryParameters: {"lastMessageId": lastMessageId},
      fromJson: (x) => MessagesResponseDto.fromJson(x),
      );

    return response;
  }
}
