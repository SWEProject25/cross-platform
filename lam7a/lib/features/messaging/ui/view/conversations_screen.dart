import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/dm_app_bar.dart';

class ConversationsScreen extends ConsumerWidget {
  static const routeName = '/dm';

  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final dMListPageViewModel = ref.watch(conversationsViewModelProvider);
    return Scaffold(
      // appBar: DMAppBar(title: 'Direct Message'),
      body: dMListPageViewModel.conversations.when(
        data: (data) {
          return data.isEmpty? 
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome to your\ninbox!", style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                Text("Drop a line, share posts and more with private conversations between you and onthers on X.", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 30),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FindContactsScreen(),
                      ),
                    );
                  },
                  child: Text("Write a message", ),
                ),
              ],
            ),
          )
          : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final chat = data[index];
              return _ChatListTile(chat: chat);
            },
          );
        },
        error: (error, stack) {
          return Center(
            child: Text('Error: $error $stack'),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FindContactsScreen(),
            ),
          );
        },
        child: AppSvgIcon(AppIcons.add_message),
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
        backgroundImage: NetworkImage(chat.avatarUrl ?? ""),
      ),
      title: Row(
        children: [
          Expanded(
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
                  style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (chat.lastMessage != null)
            Text(
              " ${timeToTimeAgo(chat.lastMessageTime!)}",
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
      subtitle: (chat.lastMessage != null) ? Text(
        chat.lastMessage!,
        style: theme.textTheme.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ) : null,
      onTap: () {
        // TODO: Navigate to chat detail page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversationId: chat.id),
          ),
        );
      },
    );
  }
}