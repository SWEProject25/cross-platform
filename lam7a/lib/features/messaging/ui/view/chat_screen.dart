import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/chat_input_bar.dart';
import 'package:lam7a/features/messaging/ui/widgets/messages_list_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreen extends ConsumerWidget {
  static const routeName = '/chat';

  final String id;
  final Contact? contact;

  const ChatScreen({super.key, required this.id, this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatViewModel = ref.watch(chatViewModelProvider(id, contact));
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(chatViewModel.contact),
      
        // Body
        body: Column(
          children: [
            // MessagesListView(messages: []),
            // Profile section
            // _buildProfileInfo(),
            Expanded(
              child: chatViewModel.messages.when(
                data: (messages) => MessagesListView(
                  messages: messages,
                  leading: _buildProfileInfo(),
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
      
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              child: Row(children: [Expanded(child: ChatInputBar())]),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(AsyncValue<Contact> contact) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {},
      ),
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

  Column _buildProfileInfo() {
    return Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage("https://avatar.iran.liara.run/public"),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ask PlayStation',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Official NA Twitter Support. You can connect with PlayStation Support for assistance with',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 4),
        const Text(
          '1.9M Followers',
          style: TextStyle(color: Colors.black87, fontSize: 13),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

