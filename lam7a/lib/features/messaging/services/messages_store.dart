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
  final Map<int, List<ChatMessage>> _cache = {};

  /// Box name per chat
  String _boxName(int chatId) => 'chat_messages_$chatId';

  /// Add multiple messages
  Future<void> addMessages(int chatId, List<ChatMessage> newMessages) async {
    for (var msg in newMessages) {
      print('Adding message to chat $chatId: ${msg.id} - ${msg.text}');
    }

    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>(_boxName(chatId));

    // In-memory cache
    final existing = _cache[chatId] ?? [];
    final existingMap = {for (var m in existing) m.id: m};

    for (var msg in newMessages) {
      existingMap[msg.id] = msg;
      // Store in Hive with string keys
      await box.put(msg.id.toString(), msg);
    }

    final updatedList = existingMap.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    _cache[chatId] = updatedList;
  }

  /// Add a single message
  Future<void> addMessage(int chatId, ChatMessage message) async {
    await addMessages(chatId, [message]);
  }

  /// Remove a message
  Future<void> removeMessage(int chatId, int messageId) async {
    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>(_boxName(chatId));

    // Remove from cache
    _cache[chatId]?.removeWhere((m) => m.id == messageId);

    // Remove from Hive using string key
    await box.delete(messageId.toString());
  }

  /// Get all messages (merged from cache or Hive)
  Future<List<ChatMessage>> getMessages(int chatId) async {
    final box = await HiveTypes().openBoxIfNeeded<ChatMessage>(_boxName(chatId));

    final all = box.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    // Update cache
    _cache[chatId] = all;

    for (var msg in all) {
      print('Adding message to chat $chatId: ${msg.id} - ${msg.text}');
    }

    return all;
  }

  /// Last message ID (max) from cache
  int getLastMessageId(int chatId) {
    final list = _cache[chatId];
    if (list == null || list.isEmpty) return 0;

    return list.map((m) => m.id).reduce((a, b) => a > b ? a : b);
  }
}
