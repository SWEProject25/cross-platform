import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';
import 'package:lam7a/features/messaging/ui/widgets/chat_input_bar.dart';
import 'package:lam7a/features/messaging/ui/widgets/message_tile.dart';
import 'package:lam7a/features/messaging/ui/widgets/messages_list_view.dart';
import 'package:lam7a/features/messaging/ui/widgets/network_avatar.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreen extends ConsumerWidget {
  static const routeName = '/chat';

  final int? conversationId;
  final int? userId;
  final Contact? contact;

  const ChatScreen({
    super.key,
    this.conversationId,
    this.userId,
    this.contact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get conv id and user id from args if not provided
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final conversationId = this.conversationId ?? args?['conversationId'];
    final userId = this.userId ?? args?['userId'];
    
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(connectionState, context, chatState.contact),

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
                        : _buildProfileInfo(chatState.contact),
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

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              child: Row(
                children: [
                  Expanded(
                    child: ChatInputBar(
                      key: Key(MessagingUIKeys.chatInputBar),
                      onSend: () => chatViewModel.sendMessage(),
                      onUpdate: (draft) => chatViewModel.updateDraftMessage(draft),
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

  AppBar _buildAppBar(AsyncValue<bool> connectionState, BuildContext context, AsyncValue<Contact> contact) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Skeletonizer(
        enabled: contact.isLoading,
        child: Row(
          children: [
            Container(   
              width: 36,           
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: ClipOval(
                child: Image.network(
                  contact.value?.avatarUrl ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.isLoading? 'Ask PlayStation' : contact.value?.name ?? 'Unknown',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  contact.isLoading? '@AskPlayStation' : contact.value?.handle ?? '@Unknown',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),




      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            key: Key(MessagingUIKeys.chatScreenConnectionStatus),
            radius: 16,
            backgroundColor: !connectionState.hasValue || !connectionState.value! ? Colors.red : Colors.green,
          ),
        )
      ],
    );
  }

  Widget _buildProfileInfo(AsyncValue<Contact> contact) {
    return Skeletonizer(
      enabled: contact.isLoading,
      child: Column(
        children: [
          const SizedBox(height: 32),
          NetworkAvatar(url: contact.value?.avatarUrl, radius: 32),
          const SizedBox(height: 8),
          Text(
            contact.isLoading? 'Ask PlayStation' : contact.value?.name ?? "Unknown",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          
          if(contact.isLoading || contact.value?.bio != null)
            const SizedBox(height: 4),
          if(contact.isLoading || contact.value?.bio != null)
          Text(
            contact.isLoading? 'Official NA Twitter Support. You can connect with PlayStation Support for assistance with' : contact.value?.bio ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            contact.isLoading? '1,000,000 Followers' : '${compressFollowerCount(contact.value?.totalFollowers ?? 1000000)} Followers',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
