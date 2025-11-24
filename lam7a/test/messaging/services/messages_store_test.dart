import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
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

  setUp(() {
    store = MessagesStore();
  });

  test('addMessages sorts by time and merges correctly', () {
    final m1 = msg(1, "one", DateTime(2024, 1, 1));
    final m2 = msg(2, "two", DateTime(2024, 1, 3));
    final m3 = msg(3, "three", DateTime(2024, 1, 2));

    store.addMessages(10, [m2, m1]);
    store.addMessages(10, [m3]); // this tests merging

    final result = store.getMessages(10);

    expect(result.length, 3);
    expect(result[0].id, 1);
    expect(result[1].id, 3);
    expect(result[2].id, 2);
  });

  test('addMessage calls addMessages internally', () {
    final m = msg(5, "hello", DateTime(2024, 1, 1));

    store.addMessage(2, m);

    final result = store.getMessages(2);

    expect(result.length, 1);
    expect(result.first.id, 5);
  });

  test('removeMessage removes a message if exists', () {
    final m1 = msg(1, "A", DateTime.now());
    final m2 = msg(2, "B", DateTime.now());

    store.addMessages(7, [m1, m2]);

    store.removeMessage(7, 1);

    final result = store.getMessages(7);

    expect(result.length, 1);
    expect(result.first.id, 2);
  });

  test('removeMessage does nothing if ID not found', () {
    final m = msg(10, "test", DateTime.now());

    store.addMessage(3, m);

    store.removeMessage(3, 999);

    final result = store.getMessages(3);
    expect(result.length, 1);
    expect(result.first.id, 10);
  });

  test('getMessages creates list if chatId absent', () {
    final result = store.getMessages(999);

    expect(result, isA<List<ChatMessage>>());
    expect(result.isEmpty, true);
  });

  test('getLastMessageId returns 0 when no messages exist', () {
    expect(store.getLastMessageId(500), 0);
  });

  test('getLastMessageId returns smallest ID (min)', () {
    store.addMessages(1, [
      msg(10, "A", DateTime.now()),
      msg(3, "B", DateTime.now()),
      msg(7, "C", DateTime.now()),
    ]);

    final id = store.getLastMessageId(1);

    expect(id, 3); // smallest ID
  });

  test('messagesStore provider returns a MessagesStore instance', () {
    final container = ProviderContainer();
    final store = container.read(messagesStoreProvider);

    expect(store, isA<MessagesStore>());
  });

}
