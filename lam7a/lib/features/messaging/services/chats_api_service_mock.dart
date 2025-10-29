// import 'package:lam7a/features/messaging/model/contact.dart';
// import 'package:lam7a/features/messaging/model/conversation.dart';
// import 'package:lam7a/features/messaging/model/chat_message.dart';
// import 'package:lam7a/features/messaging/services/chats_api_service.dart';

// class ChatsApiServiceMock implements ChatsApiService {
//   @override
//   Future<List<Conversation>> getConversations() {
//     return Future.delayed(const Duration(seconds: 2), () {
//       return [
//         Conversation(
//           id: '1',
//           name: 'Lujain Hariri',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'The presentation slides are ready to review.',
//           lastMessageTime: DateTime(2025, 10, 14, 10, 32),
//         ),
//         Conversation(
//           id: '2',
//           name: 'ByteLab Developers',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Server maintenance scheduled for midnight ⚙️',
//           lastMessageTime: DateTime(2025, 10, 13, 18, 20),
//         ),
//         Conversation(
//           id: '3',
//           name: 'Khaled M. Taha',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Can you confirm the final logo colors?',
//           lastMessageTime: DateTime(2025, 10, 12, 9, 41),
//         ),
//         Conversation(
//           id: '4',
//           name: 'UrbanTaste Café',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Your order #4932 has been confirmed ☕️',
//           lastMessageTime: DateTime(2025, 10, 11, 15, 05),
//         ),
//         Conversation(
//           id: '5',
//           name: 'Aya Rashed',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Can we move the call to 8:30?',
//           lastMessageTime: DateTime(2025, 10, 10, 21, 17),
//         ),
//         Conversation(
//           id: '6',
//           name: 'Tariq Works',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'The 3D model looks amazing 🔥',
//           lastMessageTime: DateTime(2025, 10, 8, 11, 45),
//         ),
//         Conversation(
//           id: '7',
//           name: 'QuickBank Support',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Your verification is now complete ✅',
//           lastMessageTime: DateTime(2025, 10, 6, 14, 22),
//         ),
//         Conversation(
//           id: '8',
//           name: 'Nourhan El-Masry',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//           lastMessage: 'Thanks for the help earlier!',
//           lastMessageTime: DateTime(2025, 10, 5, 16, 33),
//         ),
//       ];
//     });
//   }

//   @override
//   Future<List<Contact>> getContacts() {
//     return Future.delayed(const Duration(seconds: 5), () {
//       return [
//         Contact(
//           id: '1',
//           name: 'Lujain Hariri',
//           handle: '@lujain.dev',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '2',
//           name: 'ByteLab Developers',
//           handle: '@bytelab_io',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '3',
//           name: 'Khaled M. Taha',
//           handle: '@khaledmt',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '4',
//           name: 'UrbanTaste Café',
//           handle: '@urbantaste',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '5',
//           name: 'Aya Rashed',
//           handle: '@ayarash',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '6',
//           name: 'Tariq Works',
//           handle: '@tariqworks',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '7',
//           name: 'QuickBank Support',
//           handle: '@quickbank',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//         Contact(
//           id: '8',
//           name: 'Nourhan El-Masry',
//           handle: '@nourhanem',
//           avatarUrl: 'https://avatar.iran.liara.run/public',
//         ),
//       ];
//     });
//   }
// @override
// Future<List<ChatMessage>> getMessages(String conversationId) {
//   return Future.delayed(const Duration(seconds: 3), () {
//     return [
//       ChatMessage(id: 1, text: "Hi!", time: DateTime(2023, 6, 18, 10, 31), isMine: true),
//       ChatMessage(id: 2, text: "Ziad!", time: DateTime(2023, 6, 18, 10, 31), isMine: true),
//       ChatMessage(id: 3, text: "How are you?", time: DateTime(2023, 6, 18, 10, 31), isMine: false),
//       ChatMessage(id: 4, text: "Good, you?", time: DateTime(2023, 6, 18, 10, 32), isMine: true),
//       ChatMessage(id: 5, text: "Fine! Just busy with work.", time: DateTime(2023, 6, 18, 10, 33), isMine: false),
//       ChatMessage(id: 6, text: "Yeah same here.", time: DateTime(2023, 6, 18, 10, 35), isMine: true),
//       ChatMessage(id: 7, text: "We should catch up sometime.", time: DateTime(2023, 6, 18, 10, 36), isMine: false),
//       ChatMessage(id: 8, text: "Definitely. Maybe this weekend?", time: DateTime(2023, 6, 18, 10, 37), isMine: true),

//       // Afternoon
//       ChatMessage(id: 9, text: "Hey, did you check the files I sent?", time: DateTime(2023, 6, 18, 15, 12), isMine: false),
//       ChatMessage(id: 10, text: "Not yet, I’ll review them after lunch.", time: DateTime(2023, 6, 18, 15, 15), isMine: true),
//       ChatMessage(id: 11, text: "Alright, no rush.", time: DateTime(2023, 6, 18, 15, 16), isMine: false),

//       // Next day
//       ChatMessage(id: 12, text: "Morning!", time: DateTime(2023, 6, 19, 8, 55), isMine: false),
//       ChatMessage(id: 13, text: "Morning ☀️", time: DateTime(2023, 6, 19, 8, 56), isMine: true),
//       ChatMessage(id: 14, text: "Fine!", time: DateTime(2023, 6, 19, 9, 0), isMine: false),
//       ChatMessage(id: 15, text: "Great!", time: DateTime(2023, 6, 19, 9, 5), isMine: true),
//       ChatMessage(id: 16, text: "Talk later.", time: DateTime(2023, 6, 19, 22, 0), isMine: false),

//       // New day (June 20)
//       ChatMessage(id: 17, text: "Hey, about tomorrow’s meeting...", time: DateTime(2023, 6, 20, 11, 30), isMine: false),
//       ChatMessage(id: 18, text: "Yes?", time: DateTime(2023, 6, 20, 11, 31), isMine: true),
//       ChatMessage(id: 19, text: "Can we move it to 3 PM?", time: DateTime(2023, 6, 20, 11, 31), isMine: false),
//       ChatMessage(id: 20, text: "Sure, works for me.", time: DateTime(2023, 6, 20, 11, 33), isMine: true),
//       ChatMessage(id: 21, text: "Thanks!", time: DateTime(2023, 6, 20, 11, 34), isMine: false),

//       // Later that day
//       ChatMessage(id: 22, text: "By the way, check your email.", time: DateTime(2023, 6, 20, 17, 42), isMine: false),
//       ChatMessage(id: 23, text: "Okay, I’ll do that now.", time: DateTime(2023, 6, 20, 17, 43), isMine: true),
//       ChatMessage(id: 24, text: "Got it. Looks good.", time: DateTime(2023, 6, 20, 17, 49), isMine: true),
//       ChatMessage(id: 25, text: "Perfect 👍", time: DateTime(2023, 6, 20, 17, 50), isMine: false),

//       // Another day (June 21)
//       ChatMessage(id: 26, text: "You there?", time: DateTime(2023, 6, 21, 13, 15), isMine: false),
//       ChatMessage(id: 27, text: "Yep, just got back from lunch.", time: DateTime(2023, 6, 21, 13, 16), isMine: true),
//       ChatMessage(id: 28, text: "Cool. The report is final now.", time: DateTime(2023, 6, 21, 13, 17), isMine: false),
//       ChatMessage(id: 29, text: "Great news!", time: DateTime(2023, 6, 21, 13, 18), isMine: true),

//       // Night chat
//       ChatMessage(id: 30, text: "Long day 😪", time: DateTime(2023, 6, 21, 22, 11), isMine: false),
//       ChatMessage(id: 31, text: "Tell me about it 😅", time: DateTime(2023, 6, 21, 22, 12), isMine: true),
//       ChatMessage(id: 32, text: "Goodnight!", time: DateTime(2023, 6, 21, 22, 13), isMine: false),
//       ChatMessage(id: 33, text: "Night 🌙", time: DateTime(2023, 6, 21, 22, 14), isMine: true),
//     ];
//   });
// }

// }
