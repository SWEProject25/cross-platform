import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/ui/widgets/chat_input_bar.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';

void main() {
  group('ChatInputBar Tests', () {
    testWidgets('renders with initial empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
            ),
          ),
        ),
      );

      expect(find.text('Start a message...'), findsOneWidget);
      expect(find.byKey(Key(MessagingUIKeys.chatInputSendButton)), findsOneWidget);
    });

    testWidgets('renders with draft message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Hello World',
            ),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('send button is disabled when message is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
              onSend: () {},
            ),
          ),
        ),
      );

      final sendButton = tester.widget<IconButton>(
        find.byKey(Key(MessagingUIKeys.chatInputSendButton)),
      );
      
      expect(sendButton.onPressed, isNull);
    });

    testWidgets('send button is enabled when message is not empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Hello',
              onSend: () {},
            ),
          ),
        ),
      );

      final sendButton = tester.widget<IconButton>(
        find.byKey(Key(MessagingUIKeys.chatInputSendButton)),
      );
      
      expect(sendButton.onPressed, isNotNull);
    });

    testWidgets('calls onSend when send button is pressed', (tester) async {
      bool sendCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Test message',
              onSend: () {
                sendCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key(MessagingUIKeys.chatInputSendButton)));
      await tester.pump();

      expect(sendCalled, true);
    });

    testWidgets('expands when tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
            ),
          ),
        ),
      );

      // Tap the gesture detector to expand
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Text field should now be visible
      expect(find.byKey(Key(MessagingUIKeys.chatInputTextField)), findsOneWidget);
    });

    testWidgets('calls onUpdate when text is changed', (tester) async {
      String? updatedText;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
              onUpdate: (text) {
                updatedText = text;
              },
            ),
          ),
        ),
      );

      // Expand the input
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Enter text
      await tester.enterText(
        find.byKey(Key(MessagingUIKeys.chatInputTextField)),
        'New message',
      );

      expect(updatedText, 'New message');
    });

    testWidgets('collapses when focus is lost', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ChatInputBar(
                  draftMessage: '',
                ),
                TextField(key: Key('other_field')),
              ],
            ),
          ),
        ),
      );

      // Expand the input
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Text field should be visible
      expect(find.byKey(Key(MessagingUIKeys.chatInputTextField)), findsOneWidget);

      // Focus on another field
      await tester.tap(find.byKey(Key('other_field')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Wait for collapse animation
      await tester.pumpAndSettle();
    });

    testWidgets('handles whitespace-only messages as empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '   ',
              onSend: () {},
            ),
          ),
        ),
      );

      final sendButton = tester.widget<IconButton>(
        find.byKey(Key(MessagingUIKeys.chatInputSendButton)),
      );
      
      expect(sendButton.onPressed, isNull);
    });

    testWidgets('displays trimmed draft message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '  Multiple   spaces   test  ',
            ),
          ),
        ),
      );

      expect(find.text('Multiple spaces test'), findsOneWidget);
    });

    testWidgets('does not call onSend when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Test',
            ),
          ),
        ),
      );

      // Should not throw error when tapping
      await tester.tap(find.byKey(Key(MessagingUIKeys.chatInputSendButton)));
      await tester.pump();
    });

    testWidgets('does not call onUpdate when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
            ),
          ),
        ),
      );

      // Expand the input
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Should not throw error when entering text
      await tester.enterText(
        find.byKey(Key(MessagingUIKeys.chatInputTextField)),
        'Test',
      );
      await tester.pump();
    });

    testWidgets('cursor positioned at end of draft message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Hello',
            ),
          ),
        ),
      );

      // Expand the input
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      final textField = tester.widget<TextField>(
        find.byKey(Key(MessagingUIKeys.chatInputTextField)),
      );
      
      final controller = textField.controller!;
      expect(controller.selection.baseOffset, 5);
      expect(controller.selection.extentOffset, 5);
    });

    testWidgets('animations complete without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: '',
            ),
          ),
        ),
      );

      // Expand
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(Key(MessagingUIKeys.chatInputTextField)), findsOneWidget);
    });

    testWidgets('handles rapid expand/collapse', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ChatInputBar(
                  draftMessage: '',
                ),
                TextField(key: Key('other_field')),
              ],
            ),
          ),
        ),
      );

      // Expand
      await tester.tap(find.byKey(Key('chat_input_gesture_detector')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Immediately collapse by focusing elsewhere
      await tester.tap(find.byKey(Key('other_field')));
      await tester.pump();
      
      // Should handle without errors
      await tester.pumpAndSettle();
    });

    testWidgets('widget disposes properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatInputBar(
              draftMessage: 'Test',
            ),
          ),
        ),
      );

      // Remove widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        ),
      );

      // Should dispose without errors
      expect(tester.takeException(), isNull);
    });
  });
}
