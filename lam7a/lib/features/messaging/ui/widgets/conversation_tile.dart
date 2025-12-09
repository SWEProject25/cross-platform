import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/core/widgets/time_ago_text.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';

class ConversationTile extends ConsumerWidget {
  final int id;
  final Conversation conversation;

  const ConversationTile({required this.id, required this.conversation, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    var state = ref.watch(conversationViewmodelProvider(id));

    var lastMessage = state.lastMessage ?? conversation.lastMessage;
    var lastMessageTime = state.lastMessageTime ?? conversation.lastMessageTime;
    var unseenCount = state.unseenCount ?? conversation.unseenCount;


    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: 
            AppUserAvatar(radius: 24, displayName: conversation.name, imageUrl: conversation.avatarUrl),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  conversation.name,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    " @${conversation.username.toLowerCase().replaceAll(' ', '')}",
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (lastMessage != null)
            TimeAgoText(
              time: lastMessageTime!,
              style: theme.textTheme.bodyMedium,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 3,
              backgroundColor:
                unseenCount > 0 ? theme.colorScheme.primary : Colors.transparent,
            ),
          ),

        ],
      ),
      subtitle: (lastMessage != null)
          ? Text(
              state.isTyping ? "Typing..." : lastMessage,
              style: state.isTyping
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade900,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: unseenCount > 0 ? FontWeight.bold : null
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        ref.read(conversationViewmodelProvider(id).notifier).markConversationAsSeen();
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: {
            'userId': conversation.userId,
            'conversationId': conversation.id,
          },
        );
      },
    );
  }
}
