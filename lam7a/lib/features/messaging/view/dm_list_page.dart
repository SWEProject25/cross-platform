import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:lam7a/features/messaging/viewmodel/dm_list_page_viewmodel.dart';
import 'package:timeago/timeago.dart' as timeago;

class DMListPage extends ConsumerWidget {
  const DMListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(dMListPageViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search Direct Messages',
              leading: const Icon(Icons.search),
              elevation: MaterialStateProperty.all(0),
            ),
          ),
        ),
      ),
      body: conversations.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final chat = data[index];
              return _ChatListTile(chat: chat);
            },
          );
        },
        error: (error, stack) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new message
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final Conversation chat;

  const _ChatListTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(chat.avatarUrl),
      ),
      title: Row(
        children: [
          Expanded(
            child: Container(

              child: Row(
                children: [
                  Text(
                    chat.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                    " @${chat.name.toLowerCase().replaceAll(' ', '')}",
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            timeago.format(chat.lastMessageTime),
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // TODO: Navigate to chat detail page
      },
    );
  }
}

class ChatPreview {
  final String username;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatPreview({
    required this.username,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}

// Dummy data for preview
final _dummyChats = [
  ChatPreview(
    username: 'Ask Playstation',
    avatarUrl:
        'https://yt3.googleusercontent.com/ytc/AIdro_nEN71IruagxO6OBbgr7P1AoW-aimOMfL9S7h_yD8mT_TQ=s900-c-k-c0x00ffffff-no-rj',
    lastMessage: 'Hey, how are you doing?',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  ChatPreview(
    username: 'Jane Smith',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    lastMessage:
        'The meeting is scheduled for tomorrow at 10 AM. Don\'t forget to bring the presentation materials!',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ChatPreview(
    username: 'Mike Johnson',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    lastMessage: 'Thanks for your help!',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ChatPreview(
    username: 'Sarah Wilson',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
    lastMessage: 'See you at the conference 👋',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
  ),
];