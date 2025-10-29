import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/dtos/conversation_dto.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_repositories.g.dart';

@riverpod
Future<ChatsRepository> chatsRepository(Ref ref) async {
  return ChatsRepository(
    await ref.read(chatsApiServiceProvider),
    ref.watch(authenticationProvider),
  );
}

class ChatsRepository {
  final ChatsApiService _apiService;
  final AuthState _authState;

  ChatsRepository(this._apiService, this._authState);

  Future<List<Conversation>> fetchConversations() async {
    if (!_authState.isAuthenticated) return [];

    var conversationsDto = await _apiService.getConversations();

    var conversations = conversationsDto.data!.map((x) {
      return Conversation(
        id: x.id.toString(),
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

  Future<List<ChatMessage>> fetchMessages(String conversationId) async {
    return await _apiService.getMessages(conversationId);
  }
}
