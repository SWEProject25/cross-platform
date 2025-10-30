import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_repositories.g.dart';

@riverpod
ConversationsRepository conversationsRepository(Ref ref) {
  return ConversationsRepository(
    ref.read(dmsApiServiceProvider),
    ref.watch(authenticationProvider),
  );
}

class ConversationsRepository {
  final DMsApiService _apiService;
  final AuthState _authState;

  ConversationsRepository(this._apiService, this._authState);

  Future<List<Conversation>> fetchConversations() async {
    if (!_authState.isAuthenticated) return [];

    var conversationsDto = await _apiService.getConversations();

    var conversations = conversationsDto.data!.map((x) {
      return Conversation(
        id: x.id,
        name: x.user.displayName,
        avatarUrl: x.user.profileImageUrl,
        lastMessage: x.lastMessage?.text,
        lastMessageTime: x.updatedAt,
      );
    }).toList();

    return conversations;
  }

  Future<List<Contact>> fetchContacts() async {
    return await _apiService.getContacts();
  }

  Future<int> getConversationIdByUserId(int userId) async{
    return await _apiService.createConversation(userId);
  }
}
