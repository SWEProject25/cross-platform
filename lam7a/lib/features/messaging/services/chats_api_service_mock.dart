import 'package:lam7a/features/messaging/model/Contact.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/chats_api_service.dart';

class ChatsApiServiceMock implements ChatsApiService {
  @override
  Future<List<Conversation>> getConversations() {
    return Future.delayed(const Duration(seconds: 2), () {
      return [
        Conversation(
          id: '1',
          name: 'Lujain Hariri',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'The presentation slides are ready to review.',
          lastMessageTime: DateTime(2025, 10, 14, 10, 32),
        ),
        Conversation(
          id: '2',
          name: 'ByteLab Developers',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Server maintenance scheduled for midnight ⚙️',
          lastMessageTime: DateTime(2025, 10, 13, 18, 20),
        ),
        Conversation(
          id: '3',
          name: 'Khaled M. Taha',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Can you confirm the final logo colors?',
          lastMessageTime: DateTime(2025, 10, 12, 9, 41),
        ),
        Conversation(
          id: '4',
          name: 'UrbanTaste Café',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Your order #4932 has been confirmed ☕️',
          lastMessageTime: DateTime(2025, 10, 11, 15, 05),
        ),
        Conversation(
          id: '5',
          name: 'Aya Rashed',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Can we move the call to 8:30?',
          lastMessageTime: DateTime(2025, 10, 10, 21, 17),
        ),
        Conversation(
          id: '6',
          name: 'Tariq Works',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'The 3D model looks amazing 🔥',
          lastMessageTime: DateTime(2025, 10, 8, 11, 45),
        ),
        Conversation(
          id: '7',
          name: 'QuickBank Support',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Your verification is now complete ✅',
          lastMessageTime: DateTime(2025, 10, 6, 14, 22),
        ),
        Conversation(
          id: '8',
          name: 'Nourhan El-Masry',
          avatarUrl: 'https://avatar.iran.liara.run/public',
          lastMessage: 'Thanks for the help earlier!',
          lastMessageTime: DateTime(2025, 10, 5, 16, 33),
        ),
      ];
    });
  }

  @override
  Future<List<Contact>> getContacts() {
    return Future.delayed(const Duration(seconds: 5), () {
      return [
        Contact(
          id: '1',
          name: 'Lujain Hariri',
          handle: '@lujain.dev',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '2',
          name: 'ByteLab Developers',
          handle: '@bytelab_io',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '3',
          name: 'Khaled M. Taha',
          handle: '@khaledmt',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '4',
          name: 'UrbanTaste Café',
          handle: '@urbantaste',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '5',
          name: 'Aya Rashed',
          handle: '@ayarash',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '6',
          name: 'Tariq Works',
          handle: '@tariqworks',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '7',
          name: 'QuickBank Support',
          handle: '@quickbank',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
        Contact(
          id: '8',
          name: 'Nourhan El-Masry',
          handle: '@nourhanem',
          avatarUrl: 'https://avatar.iran.liara.run/public',
        ),
      ];
    });
  }

  @override
  Future<List<ChatMessage>> getMessages() {
    return Future.delayed(const Duration(seconds: 3), () {
      return [
        ChatMessage(text: "Hi!", time: DateTime(2023, 6, 18, 10, 31), isMine: true),
        ChatMessage(
          text: "Ziad!",
          time: DateTime(2023, 6, 18, 10, 31),
          isMine: true,
        ),
        ChatMessage(
          text: "How are you?",
          time: DateTime(2023, 6, 18, 10, 31),
          isMine: false,
        ),
        ChatMessage(
          text: "Good, you?",
          time: DateTime(2023, 6, 18, 10, 32),
          isMine: true,
        ),
        ChatMessage(
          text: "Fine! Just busy with work.",
          time: DateTime(2023, 6, 18, 10, 33),
          isMine: false,
        ),
        ChatMessage(
          text: "Yeah same here.",
          time: DateTime(2023, 6, 18, 10, 35),
          isMine: true,
        ),
        ChatMessage(
          text: "We should catch up sometime.",
          time: DateTime(2023, 6, 18, 10, 36),
          isMine: false,
        ),
        ChatMessage(
          text: "Definitely. Maybe this weekend?",
          time: DateTime(2023, 6, 18, 10, 37),
          isMine: true,
        ),

        // Afternoon
        ChatMessage(
          text: "Hey, did you check the files I sent?",
          time: DateTime(2023, 6, 18, 15, 12),
          isMine: false,
        ),
        ChatMessage(
          text: "Not yet, I’ll review them after lunch.",
          time: DateTime(2023, 6, 18, 15, 15),
          isMine: true,
        ),
        ChatMessage(
          text: "Alright, no rush.",
          time: DateTime(2023, 6, 18, 15, 16),
          isMine: false,
        ),

        // Next day
        ChatMessage(
          text: "Morning!",
          time: DateTime(2023, 6, 19, 8, 55),
          isMine: false,
        ),
        ChatMessage(
          text: "Morning ☀️",
          time: DateTime(2023, 6, 19, 8, 56),
          isMine: true,
        ),
        ChatMessage(
          text: "Fine!",
          time: DateTime(2023, 6, 19, 9, 0),
          isMine: false,
        ),
        ChatMessage(
          text: "Great!",
          time: DateTime(2023, 6, 19, 9, 5),
          isMine: true,
        ),
        ChatMessage(
          text: "Talk later.",
          time: DateTime(2023, 6, 19, 22, 0),
          isMine: false,
        ),

        // New day (June 20)
        ChatMessage(
          text: "Hey, about tomorrow’s meeting...",
          time: DateTime(2023, 6, 20, 11, 30),
          isMine: false,
        ),
        ChatMessage(
          text: "Yes?",
          time: DateTime(2023, 6, 20, 11, 31),
          isMine: true,
        ),
        ChatMessage(
          text: "Can we move it to 3 PM?",
          time: DateTime(2023, 6, 20, 11, 31),
          isMine: false,
        ),
        ChatMessage(
          text: "Sure, works for me.",
          time: DateTime(2023, 6, 20, 11, 33),
          isMine: true,
        ),
        ChatMessage(
          text: "Thanks!",
          time: DateTime(2023, 6, 20, 11, 34),
          isMine: false,
        ),

        // Later that day
        ChatMessage(
          text: "By the way, check your email.",
          time: DateTime(2023, 6, 20, 17, 42),
          isMine: false,
        ),
        ChatMessage(
          text: "Okay, I’ll do that now.",
          time: DateTime(2023, 6, 20, 17, 43),
          isMine: true,
        ),
        ChatMessage(
          text: "Got it. Looks good.",
          time: DateTime(2023, 6, 20, 17, 49),
          isMine: true,
        ),
        ChatMessage(
          text: "Perfect 👍",
          time: DateTime(2023, 6, 20, 17, 50),
          isMine: false,
        ),

        // Another day (June 21)
        ChatMessage(
          text: "You there?",
          time: DateTime(2023, 6, 21, 13, 15),
          isMine: false,
        ),
        ChatMessage(
          text: "Yep, just got back from lunch.",
          time: DateTime(2023, 6, 21, 13, 16),
          isMine: true,
        ),
        ChatMessage(
          text: "Cool. The report is final now.",
          time: DateTime(2023, 6, 21, 13, 17),
          isMine: false,
        ),
        ChatMessage(
          text: "Great news!",
          time: DateTime(2023, 6, 21, 13, 18),
          isMine: true,
        ),

        // Night chat
        ChatMessage(
          text: "Long day 😪",
          time: DateTime(2023, 6, 21, 22, 11),
          isMine: false,
        ),
        ChatMessage(
          text: "Tell me about it 😅",
          time: DateTime(2023, 6, 21, 22, 12),
          isMine: true,
        ),
        ChatMessage(
          text: "Goodnight!",
          time: DateTime(2023, 6, 21, 22, 13),
          isMine: false,
        ),
        ChatMessage(
          text: "Night 🌙",
          time: DateTime(2023, 6, 21, 22, 14),
          isMine: true,
        ),
      ];
    });
  }
}
