import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/messaging/active_chat_screens.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';
import 'package:lam7a/features/messaging/ui/widgets/chat_input_bar.dart';
import 'package:lam7a/features/messaging/ui/widgets/message_tile.dart';
import 'package:lam7a/features/messaging/ui/widgets/messages_list_view.dart';
import 'package:lam7a/features/messaging/ui/widgets/network_avatar.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final int userId;
  late final int conversationId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      userId = args['userId'];
      conversationId = args['conversationId'];
    }

    ActiveChatScreens.setActive(conversationId);
  }

  @override
  void dispose() {
    ActiveChatScreens.setInactive(conversationId);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionState = ref.watch(socketConnectionProvider);
    var chatState = ref.watch(
      chatViewModelProvider(conversationId: conversationId, userId: userId),
    );
    var chatViewModel = ref.read(
      chatViewModelProvider(
        conversationId: conversationId,
        userId: userId,
      ).notifier,
    );
    var theme = Theme.of(context);
    return GestureDetector(
      key: Key('chatScreenGestureDetector'),
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: _buildAppBar(connectionState, context, chatState.conversation),

        // Body
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: chatState.messages.when(
                data: (messages) => RefreshIndicator(
                  key: Key(MessagingUIKeys.chatScreenRefreshIndicator),
                  onRefresh: () => chatViewModel.refresh(),
                  child: MessagesListView(
                    key: Key(MessagingUIKeys.messagesListView),
                    messages: messages,
                    leading: chatState.hasMoreMessages
                        ? null
                        : _buildProfileInfo(context, chatState.contact),
                    loadMore: () => chatViewModel.loadMoreMessages(),
                  ),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),

            if (chatState.isTyping)
              MessageTile(
                key: Key(MessagingUIKeys.chatScreenTypingIndicator),
                isMine: false,
                showTypingIndicator: true,
              ),

            (!chatState.conversation.isLoading &&
                    chatState.conversation.value!.isBlocked)
                ? Container(
                  height: 80,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'This user is not available.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                : Container(
                    // color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChatInputBar(
                            key: Key(MessagingUIKeys.chatInputBar),
                            onSend: () => chatViewModel.sendMessage(),
                            onUpdate: (draft) =>
                                chatViewModel.updateDraftMessage(draft),
                            draftMessage: chatState.draftMessage,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    AsyncValue<bool> connectionState,
    BuildContext context,
    AsyncValue<Conversation> contact,
  ) {
    ThemeData themeData = Theme.of(context);
    String displayName = contact.isLoading
        ? 'Ask PlayStation'
        : contact.value?.name ?? 'Unknown';

    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.white,
      title: Skeletonizer(
        enabled: contact.isLoading,
        child: Row(
          children: [
            AppUserAvatar(
              radius: 16,
              displayName: displayName,
              imageUrl: contact.value?.avatarUrl,
            ),
            // Container(
            //   width: 36,
            //   height: 36,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   child: ClipOval(
            //     child: Image.network(
            //       contact.value?.avatarUrl ?? '',
            //       width: double.infinity,
            //       height: double.infinity,
            //       fit: BoxFit.cover,
            //       errorBuilder: (context, error, stackTrace) =>
            //           const Icon(Icons.person, size: 24),
            //     ),
            //   ),
            // ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: themeData.textTheme.titleMedium,
                  //  TextStyle(
                  // color: Colors.black,
                  // fontWeight: FontWeight.w600,
                  // fontSize: 16,
                  // ),
                ),
                // Text(
                //   contact.isLoading? '@AskPlayStation' : contact.value?.handle ?? '@Unknown',
                //   style: TextStyle(color: Colors.grey, fontSize: 12),
                // ),
              ],
            ),
          ],
        ),
      ),

      actions: [
        if ((!connectionState.hasValue || !connectionState.value!))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Icon(Icons.signal_wifi_statusbar_connected_no_internet_4, size: 24, color: Colors.redAccent,),
          ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, AsyncValue<Contact> contact) {
    ThemeData theme = Theme.of(context);
    return Skeletonizer(
      enabled: contact.isLoading,
      child: Column(
        children: [
          const SizedBox(height: 32),
          AppUserAvatar(
            radius: 32,
            displayName: contact.isLoading
                ? 'Ask PlayStation'
                : contact.value?.name ?? "Unknown",
            imageUrl: contact.value?.avatarUrl,
          ),
          const SizedBox(height: 8),
          Text(
            contact.isLoading
                ? 'Ask PlayStation'
                : contact.value?.name ?? "Unknown",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          if (contact.isLoading || contact.value?.bio != null)
            const SizedBox(height: 4),
          if (contact.isLoading || contact.value?.bio != null)
            Text(
              contact.isLoading
                  ? 'Official NA Twitter Support. You can connect with PlayStation Support for assistance with'
                  : contact.value?.bio ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
          const SizedBox(height: 4),
          Text(
            contact.isLoading
                ? '1,000,000 Followers'
                : '${compressFollowerCount(contact.value?.totalFollowers ?? 1000000)} Followers',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
