import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:lam7a/features/messaging/services/chats_api_service.dart';

class ChatsApiServiceMock implements ChatsApiService {
  
  @override
  Future<List<Conversation>> getConversations() {
    return Future.delayed(const Duration(seconds: 5), () {
      return [
        Conversation(
          id: '1',
          name: 'Alice',
          avatarUrl: 'https://gravatar.com/avatar/6e4ae16acdd62f89b0f194c0566bb59b?s=400&d=robohash&r=x',
          lastMessage: 'Hey, how   are you?',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        Conversation(
          id: '2',
          name: 'Bob',
          avatarUrl: 'https://gravatar.com/avatar/6e4ae16acdd62f89b0f194c0566bb59b?s=400&d=robohash&r=x',
          lastMessage: 'Let\'s catch up later.',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
    });
  }

}