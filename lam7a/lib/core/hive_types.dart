import 'package:hive_flutter/adapters.dart';
import 'package:lam7a/features/messaging/adapters/chat_message_adapter.dart';
import 'package:lam7a/features/messaging/adapters/conversation_adapter.dart';

class HiveTypes {
  static const int chatMessage = 1;
  static const int conversation = 2;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(ConversationAdapter());
  }

  Future<Box<T>> openBoxIfNeeded<T>(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
    return await Hive.openBox<T>(name);
  }
}
