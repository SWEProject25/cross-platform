import 'package:lam7a/features/messaging/model/chat_message.dart';

class LocalCache {
  final Map<int, List<ChatMessage>> _messages = {};

  void saveMessages(int chatId, List<ChatMessage> newMessages) {
    final existing = _messages[chatId] ?? [];

    final existingIds = existing.map((m) => m.id).toSet();

    final uniqueNewMessages = newMessages
        .where((m) => !existingIds.contains(m.id))
        .toList();

    _messages[chatId] = [...existing, ...uniqueNewMessages];

    _messages[chatId]?.sort((a, b) => a.time.compareTo(b.time));
  }


  void addMessage(int chatId, ChatMessage message) {
    saveMessages(chatId, [message]);
  }

  List<ChatMessage> getMessages(int chatId) => _messages[chatId] ?? [];
}
