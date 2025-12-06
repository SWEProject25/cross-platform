import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/main.dart';
import 'package:path/path.dart';
import '../viewmodel/conversations_viewmodel.dart';

class FindContactsScreen extends ConsumerWidget {
  const FindContactsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final state = ref.watch(conversationsViewModelProvider);
    final viewModel = ref.read(conversationsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Message'),
        centerTitle: false,
        elevation: 0,
      ),
      body: state.loadingConversationId ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: viewModel.onQueryChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: const EdgeInsets.all(12),
                fillColor: theme.colorScheme.surface,
                errorText: state.searchQueryError,
              ),
            ),
          ),
          const Divider(height: 0),

          // "Create a group" row
          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundColor: Colors.blue.shade50,
          //     child: const Icon(Icons.group_add, color: Colors.blue),
          //   ),
          //   title: const Text(
          //     'Create a group',
          //     style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          //   ),
          //   onTap: () {},
          // ),

          // Conversation list
          Expanded(
            child: state.contacts.when(
              data: (conversations) => ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final c = conversations[index];
                  return ListTile(
                    leading: AppUserAvatar(
                      radius: 19,
                      imageUrl: c.avatarUrl,
                      displayName: c.name,
                      username: c.handle,
                    ),
                    title: Text(
                      c.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      c.handle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    onTap: () async {
                      var convId = await viewModel.createConversationId(c.id);

                      if (navigatorKey.currentState == null) return;

                      navigatorKey.currentState!.pop();
                      navigatorKey.currentState!.pushNamed(
                        ChatScreen.routeName,
                        arguments: {'userId': c.id, 'conversationId': convId},
                      );
                    },
                  );
                },
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

