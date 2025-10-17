import 'package:lam7a/features/messaging/model/Contact.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
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
}
