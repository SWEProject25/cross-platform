import 'package:hive_flutter/hive_flutter.dart';
import 'package:lam7a/features/messaging/adapters/chat_message_adapter.dart';
import 'package:lam7a/features/messaging/adapters/conversation_adapter.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/Explore/cache/recent_searches.dart';

class HiveTypes {
  // Existing type IDs
  static const int chatMessage = 1;
  static const int conversation = 2;

  // New type IDs
  static const int userModel = 3;

  // Box names
  static const String autocompletesBox = "autocompletes_box";
  static const String usersBox = "users_box";

  // ----------------------------------------
  // INITIALIZE
  // ----------------------------------------
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register messaging adapters
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(ConversationAdapter());

    // Register your UserModel adapter
    if (!Hive.isAdapterRegistered(userModel)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    // Open boxes if they are not opened
    await _openIfNotOpen<String>(autocompletesBox);
    await _openIfNotOpen<UserModel>(usersBox);
  }

  // ----------------------------------------
  // UTILITY: open box only once
  // ----------------------------------------
  static Future<Box<T>> _openIfNotOpen<T>(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
    return Hive.openBox<T>(name);
  }

  Future<Box<T>> openBoxIfNeeded<T>(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
    return Hive.openBox<T>(name);
  }
}
