// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
// import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
// import 'package:lam7a/features/messaging/ui_keys.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:lam7a/features/messaging/model/contact.dart';
// import 'package:lam7a/features/messaging/model/chat_message.dart';
// import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
// import 'package:lam7a/core/services/socket_service.dart';
// import 'package:state_notifier/state_notifier.dart';

// class MockChatViewModel implements ChatViewModel {
//   @override
//   ChatState state;

//   MockChatViewModel(this.state);

//   @override
//   ChatState build({required int userId, int? conversationId}) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement conversationId
//   int? get conversationId => throw UnimplementedError();

//   @override
//   RemoveListener listenSelf(void Function(ChatState? previous, ChatState next) listener, {void Function(Object error, StackTrace stackTrace)? onError}) {
//     // TODO: implement listenSelf
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> loadMoreMessages() async {
//   }

//   @override
//   // TODO: implement ref
//   Ref get ref => throw UnimplementedError();

//   @override
//   Future<void> refresh() async {
    
//   }

//   @override
//   void runBuild() {
//     // TODO: implement runBuild
//   }

//   @override
//   Future<void> sendMessage() async {
//   }

//   @override
//   // TODO: implement stateOrNull
//   ChatState? get stateOrNull => throw UnimplementedError();

//   @override
//   void updateDraftMessage(String draft)  {
//   }

//   @override
//   bool updateShouldNotify(ChatState previous, ChatState next) {
//     // TODO: implement updateShouldNotify
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement userId
//   int get userId => throw UnimplementedError();
// }
// class MockAsyncNotifier extends Fake implements AsyncNotifier {}

// class MockSocketConn extends Mock implements SocketService {}

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late MockChatViewModel mockVM;

//   ProviderContainer makeContainer({
//     required AsyncValue<List<ChatMessage>> messages,
//     required AsyncValue<Contact> contact,
//     required bool connection,
//     bool isTyping = false,
//     String draft = "",
//     bool hasMore = false,
//   }) {

//     final state = ChatState(
//       contact: contact,
//       draftMessage: draft,
//       messages: messages,
//       isTyping: isTyping,
//       hasMoreMessages: hasMore,
//     );

//     mockVM = MockChatViewModel(state);


//     // when(() => mockVM.state).thenReturn(state);
//     // when(() => mockVM.refresh()).thenAnswer((_) async {});
//     // when(() => mockVM.loadMoreMessages()).thenAnswer((_) async {});
//     // when(() => mockVM.sendMessage()).thenAnswer((_) async {});
//     // when(() => mockVM.updateDraftMessage(any())).thenAnswer((_) async {});

//     final container = ProviderContainer(
//       overrides: [
//         chatViewModelProvider(conversationId: 1, userId: 10)
//             .overrideWith(() => mockVM),
//         socketConnectionProvider.overrideWithValue(AsyncValue.data(connection)),
//       ],
//     );

//     return container;
//   }

//   Widget makeWidget(ProviderContainer container) {
//     return UncontrolledProviderScope(
//       container: container,
//       child:  MaterialApp(
//         home: ChatScreen(conversationId: 1, userId: 10),
//       ),
//     );
//   }

//   group("ChatScreen widget tests", () {

//     testWidgets("shows loading state", (tester) async {
//       final container = makeContainer(
//         messages:  AsyncValue.loading(),
//         contact:  AsyncValue.loading(),
//         connection: false,
//       );

//       await tester.pumpWidget(makeWidget(container));

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       expect(find.byKey( Key("chatScreenConnectionStatus")), findsOneWidget);
//     });

//     testWidgets("shows error state", (tester) async {
//       final container = makeContainer(
//         messages:  AsyncValue.error("ERR", StackTrace.empty),
//         contact: AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "z")),
//         connection: true,
//       );

//       await tester.pumpWidget(makeWidget(container));

//       expect(find.text("Error: ERR"), findsOneWidget);
//       expect(find.byKey( Key("chatScreenConnectionStatus")), findsOneWidget);
//     });

//     testWidgets("shows messages list when data available", (tester) async {
//       final msgs = [
//         ChatMessage(
//           id: 1,
//           senderId: 10,
//           conversationId: 1,
//           text: "Hi",
//           time: DateTime(2024),
//           isMine: true,
//         ),
//       ];

//       final container = makeContainer(
//         messages: AsyncValue.data(msgs),
//         contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
//         connection: true,
//       );

//       await tester.pumpWidget(makeWidget(container));
//       await tester.pumpAndSettle();

//       expect(find.byKey( Key("messagesListView")), findsOneWidget);
//       expect(find.byKey( Key("chatInputBar")), findsOneWidget);
//     });

//     testWidgets("typing indicator is shown", (tester) async {
//       final container = makeContainer(
//         messages: AsyncValue.data([]),
//         contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
//         connection: true,
//         isTyping: true,
//       );

//       await tester.pumpWidget(makeWidget(container));
//       expect(find.byKey( Key("chatScreenTypingIndicator")), findsOneWidget);
//     });

// // testWidgets("ChatInputBar calls updateDraft and sendMessage", (tester) async {
// //   bool sendCalled = false;
// //   String updatedDraft = "";

// //   final container = makeContainer(
// //     messages: AsyncValue.data([]),
// //     contact: AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
// //     connection: true,
// //   );

// //   await tester.pumpWidget(makeWidget(container));
// //   await tester.pump(); // start build

// //   // Tap the preview to expand the input bar
// //   final openButton = find.byKey(const Key("chat_input_gesture_detector"));
// //   await tester.tap(openButton);
// //   await tester.pump(); // start animations

// //   // Pump enough time for fade + slide + expand delay
// //   await tester.pump(const Duration(milliseconds: 600));

// //   // Now TextField is visible
// //   final textField = find.byType(TextField);
// //   expect(textField, findsOneWidget);

// //   // Enter text
// //   await tester.enterText(textField, "Hello");
// //   await tester.pump();

// //   // Simulate the updateDraft callback
// //   updatedDraft = "Hello"; // or call your mock verify here
// //   expect(updatedDraft, "Hello");

// //   // Press the send button
// //   final sendButton = find.byKey(Key(MessagingUIKeys.chatInputSendButton));
// //   expect(sendButton, findsOneWidget);
// //   await tester.tap(sendButton);
// //   await tester.pump();

// //   // Simulate send callback
// //   sendCalled = true;
// //   expect(sendCalled, isTrue);
// // });


// //     testWidgets("pull-to-refresh triggers refresh()", (tester) async {
// //       final container = makeContainer(
// //         messages: AsyncValue.data([]),
// //         contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
// //         connection: true,
// //       );

// //       await tester.pumpWidget(makeWidget(container));
// //       await tester.pump();

// //       final refreshFinder = find.byKey( Key("chatScreenRefreshIndicator"));
// //       await tester.drag(refreshFinder,  Offset(0, 200));
// //       await tester.pump( Duration(seconds: 1));

// //       verify(() => mockVM.refresh()).called(1);
// //     });

//     testWidgets("app bar shows offline status", (tester) async {
//       final container = makeContainer(
//         messages: AsyncValue.data([]),
//         contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
//         connection: false,
//       );

//       await tester.pumpWidget(makeWidget(container));

//       final circle = tester.widget<CircleAvatar>(
//         find.byKey( Key("chatScreenConnectionStatus")),
//       );

//       expect(circle.backgroundColor, Colors.red);
//     });

//     testWidgets("app bar shows online status", (tester) async {
//       final container = makeContainer(
//         messages: AsyncValue.data([]),
//         contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
//         connection: true,
//       );

//       await tester.pumpWidget(makeWidget(container));

//       final circle = tester.widget<CircleAvatar>(
//         find.byKey( Key("chatScreenConnectionStatus")),
//       );

//       expect(circle.backgroundColor, Colors.green);
//     });

//     // testWidgets("tap anywhere dismisses keyboard", (tester) async {
//     //   final container = makeContainer(
//     //     messages: AsyncValue.data([]),
//     //     contact:  AsyncValue.data(Contact(id: 1, name: "Ziad", handle: "@z")),
//     //     connection: true,
//     //   );

//     //   await tester.pumpWidget(makeWidget(container));

//     //   FocusScope.of(tester.element(find.byType(Scaffold))).requestFocus(FocusNode());
//     //   await tester.tap(find.byType(GestureDetector));
//     //   await tester.pump();

//     //   expect(FocusManager.instance.primaryFocus, isNull);
//     // });
//   });
// }
