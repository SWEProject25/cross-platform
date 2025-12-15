import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lam7a/features/messaging/adapters/chat_message_adapter.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    // Create a temporary directory for Hive
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    Hive.registerAdapter(ChatMessageAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    // Clean up temporary directory
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  late MessagesStore store;

  ChatMessage msg(int id, String text, DateTime t) {
    return ChatMessage(
      id: id,
      text: text,
      time: t,
      senderId: 1,
      isMine: true,
      conversationId: 1,
    );
  }

  setUp(() async {
    store = MessagesStore();
    // Clean up any existing boxes
    try {
      await Hive.deleteBoxFromDisk('chat_messages_10');
      await Hive.deleteBoxFromDisk('chat_messages_2');
      await Hive.deleteBoxFromDisk('chat_messages_7');
      await Hive.deleteBoxFromDisk('chat_messages_3');
      await Hive.deleteBoxFromDisk('chat_messages_999');
      await Hive.deleteBoxFromDisk('chat_messages_500');
      await Hive.deleteBoxFromDisk('chat_messages_1');
    } catch (e) {
      // Ignore if boxes don't exist
    }
  });

  tearDown(() async {
    // Clean up boxes after each test
    try {
      await Hive.deleteBoxFromDisk('chat_messages_10');
      await Hive.deleteBoxFromDisk('chat_messages_2');
      await Hive.deleteBoxFromDisk('chat_messages_7');
      await Hive.deleteBoxFromDisk('chat_messages_3');
      await Hive.deleteBoxFromDisk('chat_messages_999');
      await Hive.deleteBoxFromDisk('chat_messages_500');
      await Hive.deleteBoxFromDisk('chat_messages_1');
    } catch (e) {
      // Ignore
    }
  });

  test('addMessages sorts by time and merges correctly', () async {
    final m1 = msg(1, "one", DateTime(2024, 1, 1));
    final m2 = msg(2, "two", DateTime(2024, 1, 3));
    final m3 = msg(3, "three", DateTime(2024, 1, 2));

    await store.addMessages(10, [m2, m1]);
    await store.addMessages(10, [m3]); // this tests merging

    final result = await store.getMessages(10);

    expect(result.length, 3);
    expect(result[0].id, 1);
    expect(result[1].id, 3);
    expect(result[2].id, 2);
  });

  test('addMessage calls addMessages internally', () async {
    final m = msg(5, "hello", DateTime(2024, 1, 1));

    await store.addMessage(2, m);

    final result = await store.getMessages(2);

    expect(result.length, 1);
    expect(result.first.id, 5);
  });

  test('removeMessage removes a message if exists', () async {
    final m1 = msg(1, "A", DateTime.now());
    final m2 = msg(2, "B", DateTime.now());

    await store.addMessages(7, [m1, m2]);

    await store.removeMessage(7, 1);

    final result = await store.getMessages(7);

    expect(result.length, 1);
    expect(result.first.id, 2);
  });

  test('removeMessage does nothing if ID not found', () async {
    final m = msg(10, "test", DateTime.now());

    await store.addMessage(3, m);

    await store.removeMessage(3, 999);

    final result = await store.getMessages(3);
    expect(result.length, 1);
    expect(result.first.id, 10);
  });

  test('getMessages creates list if chatId absent', () async {
    final result = await store.getMessages(999);

    expect(result, isA<List<ChatMessage>>());
    expect(result.isEmpty, true);
  });

  test('getLastMessageId returns 0 when no messages exist', () {
    expect(store.getLastMessageId(500), 0);
  });

  test('getLastMessageId returns largest ID (max)', () async {
    await store.addMessages(1, [
      msg(10, "A", DateTime.now()),
      msg(3, "B", DateTime.now()),
      msg(7, "C", DateTime.now()),
    ]);

    final id = store.getLastMessageId(1);

    expect(id, 10); // largest ID
  });

  test('getLastMessageId returns 0 for empty chat', () async {
    await store.getMessages(1); // Initialize with empty list
    
    final id = store.getLastMessageId(1);
    
    expect(id, 0);
  });

  test('messagesStore provider returns a MessagesStore instance', () {
    final container = ProviderContainer();
    final store = container.read(messagesStoreProvider);

    expect(store, isA<MessagesStore>());
    
    container.dispose();
  });

  test('addMessages persists to Hive and retrieves correctly', () async {
    final m1 = msg(1, "A", DateTime(2024, 1, 1));
    final m2 = msg(2, "B", DateTime(2024, 1, 2));

    await store.addMessages(1, [m1, m2]);

    // Create a new store instance to verify persistence
    final newStore = MessagesStore();
    final result = await newStore.getMessages(1);

    expect(result.length, 2);
    expect(result[0].id, 1);
    expect(result[1].id, 2);
  });

  test('_boxName generates correct box name', () async {
    final m = msg(1, "test", DateTime.now());
    
    await store.addMessage(42, m);
    
    // Verify by retrieving from the correct box
    final result = await store.getMessages(42);
    expect(result.length, 1);
    expect(result.first.id, 1);
  });

  test('addMessages updates existing message with same ID', () async {
    final m1 = msg(1, "original", DateTime(2024, 1, 1));
    await store.addMessages(1, [m1]);

    final m1Updated = msg(1, "updated", DateTime(2024, 1, 1));
    await store.addMessages(1, [m1Updated]);

    final result = await store.getMessages(1);
    expect(result.length, 1);
    expect(result.first.text, "updated");
  });

  test('handles multiple chats independently', () async {
    final m1 = msg(1, "Chat1", DateTime.now());
    final m2 = msg(2, "Chat2", DateTime.now());

    await store.addMessage(1, m1);
    await store.addMessage(2, m2);

    final result1 = await store.getMessages(1);
    final result2 = await store.getMessages(2);

    expect(result1.length, 1);
    expect(result1.first.id, 1);
    expect(result2.length, 1);
    expect(result2.first.id, 2);
  });
}
