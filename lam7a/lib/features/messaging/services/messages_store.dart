import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_store.g.dart';

@Riverpod(keepAlive: true)
MessagesStore messagesStore(Ref ref){
  return MessagesStore();
}

class MessagesStore {
  final Map<int, List<ChatMessage>> _messages = {};


  void addMessages(int chatId, List<ChatMessage> newMessages) {
    final existing = _messages[chatId] ?? [];
    final existingMap = {for (var m in existing) m.id: m};

    for (var msg in newMessages) {
      existingMap[msg.id] = msg;
    }

    final updatedList = existingMap.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    _messages[chatId] = updatedList;
  }

  void addMessage(int chatId, ChatMessage message) {
    addMessages(chatId, [message]);
  }
  
  void removeMessage(int chatId, int messageId) {
    final existing = _messages[chatId];
    if (existing != null) {
      existing.removeWhere((m) => m.id == messageId);
    }
  }

  List<ChatMessage> getMessages(int chatId) => _messages.putIfAbsent(chatId, ()=>[]);
  
  int getLastMessageId(int chatId) {
    final messages = _messages[chatId];
    if (messages == null || messages.isEmpty) {
      return 0;
    }
    return messages.map((m) => m.id).reduce((a, b) => a < b ? a : b);
  }
}
