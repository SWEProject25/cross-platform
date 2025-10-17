import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/messaging/model/Conversation.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:lam7a/features/messaging/ui/view/contacts_list_view_page.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/dm_list_page_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/widgets/DMAppBar.dart';

class DMListViewPage extends ConsumerWidget {
  const DMListViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dMListPageViewModel = ref.watch(dMListPageViewModelProvider);
    return Scaffold(
      appBar: DMAppBar(title: 'Direct Message'),
      body: dMListPageViewModel.conversations.when(
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactsListPage(),
            ),
          );
        },
        child: const Icon(Icons.message),
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
          Text(
            " ${timeToTimeAgo(chat.lastMessageTime)}",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage,
        style: theme.textTheme.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // TODO: Navigate to chat detail page
      },
    );
  }
}