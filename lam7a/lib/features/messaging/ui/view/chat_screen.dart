import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/chat_input_bar.dart';
import 'package:lam7a/features/messaging/ui/widgets/messages_list_view.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreen extends ConsumerWidget {
  static const routeName = '/chat';

  final int? conversationId;
  final int? userId;
  final Contact? contact;

  const ChatScreen({super.key, this.conversationId, this.userId, this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatState = ref.watch(chatViewModelProvider(conversationId: conversationId, userId: userId));
    var chatViewModel = ref.read(chatViewModelProvider(conversationId: conversationId, userId: userId).notifier);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context, chatState.contact),
      
        // Body
        body: Column(
          children: [
            Expanded(
              child: chatState.messages.when(
                data: (messages) => RefreshIndicator(
                  onRefresh: ()=>chatViewModel.refresh(),
                  child: MessagesListView(
                    messages: messages,
                    leading: chatState.hasMoreMessages? null : _buildProfileInfo(chatState.contact),
                    loadMore: ()=> chatViewModel.loadMoreMessages(),
                  ),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
      
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              child: Row(children: [Expanded(child: ChatInputBar(onSend: (m)=>chatViewModel.sendMessage(m),))]),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AsyncValue<Contact> contact) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Skeletonizer(
        enabled: contact.isLoading,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  contact.value?.avatarUrl ?? "https://avatar.iran.liara.run/public",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.value?.name ?? 'Ask PlayStation',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  contact.value?.handle ?? '@AskPlayStation',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(AsyncValue<Contact> contact) {
    return Skeletonizer(
      enabled: contact.isLoading,
      child: Column(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(contact.value?.avatarUrl ?? "https://avatar.iran.liara.run/public"),
          ),
          const SizedBox(height: 8),
          Text(
            contact.value?.name ?? "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            contact.value?.bio ?? 'Official NA Twitter Support. You can connect with PlayStation Support for assistance with',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '${compressFollowerCount(contact.value?.totalFollowers ?? 1000000)} Followers',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

