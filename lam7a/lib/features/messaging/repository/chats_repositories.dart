import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_repositories.g.dart';

@riverpod
ChatsRepository chatsRepository(Ref ref) {
  return ChatsRepository(ref.read(chatsApiServiceProvider));
}

class ChatsRepository {

  final ChatsApiService _apiService;

  ChatsRepository(this._apiService);

  Future<List<Conversation>> fetchConversations() async {
    return await _apiService.getConversations();
  }

  Future<List<Contact>> fetchContacts() async {
    return await _apiService.getContacts();
  }

  Future<List<ChatMessage>> fetchMessages(String conversationId) async {
    return await _apiService.getMessages(conversationId);
  }
}