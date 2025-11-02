import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/common/dtos/api_response.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';

class DMsApiServiceImpl extends DMsApiService {
  final ApiService _apiService;

  DMsApiServiceImpl(this._apiService);

  @override
  Future<ApiResponse<List<ConversationDto>>> getConversations() async {
    var responseJson = await _apiService.get(endpoint: "/conversations");

    final response = ApiResponse<List<ConversationDto>>.fromJson(
      responseJson,
      (json) =>
          (json as List).map((item) => ConversationDto.fromJson(item)).toList(),
    );

    return response;
  }

  @override
  Future<int> createConversation(int userId) async {
    var responseJson = await _apiService.post(
      endpoint: "/conversations/$userId",
    );

    return int.tryParse(responseJson['data']['id'].toString()) ?? -1;
  }

  @override
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

  @override
  Future<List<Contact>> searchForContacts(
    String query,
    int page, [
    int limit = 20,
  ]) async {
    final response = await _apiService.get<List<Contact>>(
      endpoint: "/profile/search",
      queryParameters: {"query": query, "page": page, "limit": limit},
      fromJson: (dynamic x) {
        if (x is Map<String, dynamic>) {
          final list = (x['data'] ?? x['results'] ?? x['items']);
          if (list is List) {
            return list
                .cast<Map<String, dynamic>>()
                .map(
                  (json) => Contact(
                    id: json['user_id'] ?? '',
                    name: json['name'] ?? '',
                    avatarUrl: json['profile_image_url'] ?? '',
                    handle: json['User']['username'] ?? '',
                  ),
                )
                .toList();
          }
        }

        throw Exception('Unexpected response shape: ${x.runtimeType}');
      },
    );

    return response; // <- don’t forget this
  }

  @override
  Future<Contact> getContactByUserId(int userId) async {
    var profileJson = await _apiService.get(endpoint: "/profile/user/$userId");
    var followersJson = await _apiService.get(
      endpoint: "/users/$userId/followers",
    );
    print("Hello ");
    return Contact(
      id: profileJson['data']['id'],
      name: profileJson['data']['name'],
      avatarUrl: profileJson['data']['profile_image_url'],
      handle: profileJson['data']['User']['username'],
      bio: profileJson['data']['bio'],
      totalFollowers: followersJson['metadata']['totalItems'],
    );
  }
}
