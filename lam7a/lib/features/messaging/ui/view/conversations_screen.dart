import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/ui/widgets/network_avatar.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';

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
          return data.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to your\ninbox!",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Drop a line, share posts and more with private conversations between you and onthers on X.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 30),
                      FilledButton(
                        key: Key(MessagingUIKeys.conversationsEmptyStateWriteButton),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FindContactsScreen(),
                            ),
                          );
                        },
                        child: Text("Write a message"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  key: Key(MessagingUIKeys.conversationsListView),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final chat = data[index];
                    return _ChatListTile(isTyping: dMListPageViewModel.isTyping[chat.id.toString()] ?? false, chat: chat);
                  },
                );
        },
        error: (error, stack) {
          return Center(child: Text('Error: $error $stack'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: Key(MessagingUIKeys.conversationsFab),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => FindContactsScreen()));
        },
        child: AppSvgIcon(AppIcons.add_message),
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final Conversation chat;
  final bool isTyping;

  const _ChatListTile({required this.isTyping, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: NetworkAvatar(url: chat.avatarUrl, radius: 28),
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
                    " @${chat.username.toLowerCase().replaceAll(' ', '')}",
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
              style: isTyping ? theme.textTheme.bodyMedium : theme.textTheme.bodyMedium,
            ),
        ],
      ),
      subtitle: (chat.lastMessage != null)
          ? Text(
              isTyping ? "Typing..." : chat.lastMessage!,
              style: isTyping ? theme.textTheme.bodyMedium?.copyWith(color: Colors.green.shade900) : theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        // TODO: Navigate to chat detail page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(userId: chat.userId, conversationId: chat.id),
          ),
        );
      },
    );
  }
}
