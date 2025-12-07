import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/core/widgets/time_ago_text.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/network_avatar.dart';

class ConversationTile extends ConsumerWidget {
  final int id;

  const ConversationTile({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    var state = ref.watch(conversationViewmodelProvider(id));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: 
            AppUserAvatar(radius: 24, displayName: state.conversation.name, imageUrl: state.conversation.avatarUrl),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  state.conversation.name,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    " @${state.conversation.username.toLowerCase().replaceAll(' ', '')}",
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (state.conversation.lastMessage != null)
            TimeAgoText(
              time: state.conversation.lastMessageTime!,
              style: theme.textTheme.bodyMedium,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 3,
              backgroundColor:
                state.conversation.unseenCount > 0 ? theme.colorScheme.primary : Colors.transparent,
            ),
          ),

        ],
      ),
      subtitle: (state.conversation.lastMessage != null)
          ? Text(
              state.isTyping ? "Typing..." : state.conversation.lastMessage!,
              style: state.isTyping
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade900,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: state.conversation.unseenCount > 0 ? FontWeight.bold : null
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: {
            'userId': state.conversation.userId,
            'conversationId': state.conversation.id,
          },
        );
      },
    );
  }
}
