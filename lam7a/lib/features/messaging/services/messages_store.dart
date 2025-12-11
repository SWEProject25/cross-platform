import 'package:hive_flutter/hive_flutter.dart';
import 'package:lam7a/core/hive_types.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_store.g.dart';

@Riverpod(keepAlive: true)
MessagesStore messagesStore(Ref ref){
  return MessagesStore();
}

class MessagesStore {
  final Map<int, List<ChatMessage>> _messages = {};


  Future<void> addMessages(int chatId, List<ChatMessage> newMessages) async {
    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>('chat_messages_$chatId');

    final existing = _messages[chatId] ?? [];
    final existingMap = {for (var m in existing) m.id: m};

    for (var msg in newMessages) {
      existingMap[msg.id] = msg;
    }

    final updatedList = existingMap.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    _messages[chatId] = updatedList;
    
    box.putAll({for (var msg in newMessages) msg.id: msg});
  }

  Future<void> addMessage(int chatId, ChatMessage message) async {
    await addMessages(chatId, [message]);
  }
  
  Future<void> removeMessage(int chatId, int messageId) async {
    final existing = _messages[chatId];
    if (existing != null) {
      existing.removeWhere((m) => m.id == messageId);
    }

    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>('chat_messages_$chatId');
    await box.delete(messageId);
  }

  Future<List<ChatMessage>> getMessages(int chatId) async{ 
    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>('chat_messages_$chatId');

    return box.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    // return _messages.putIfAbsent(chatId, ()=>[]);
  }
  
  int getLastMessageId(int chatId) {
    final messages = _messages[chatId];
    if (messages == null || messages.isEmpty) {
      return 0;
    }
    return messages.map((m) => m.id).reduce((a, b) => a < b ? a : b);
  }
}
