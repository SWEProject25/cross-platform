import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/conversations_viewmodel.dart';

class FindContactsScreen extends ConsumerWidget {
  const FindContactsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final conversationsViewModel = ref.watch(conversationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Direct Message',
        ),
        centerTitle: false,
        elevation: 0,

      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: const EdgeInsets.all(12),
                fillColor: theme.colorScheme.surface,
              ),
            ),
          ),
          const Divider(height: 0),

          // "Create a group" row
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.group_add, color: Colors.blue),
            ),
            title: const Text(
              'Create a group',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),

          // Conversation list
          Expanded(
            child: conversationsViewModel.contacts.when(
              data: (conversations) => ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final c = conversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(c.avatarUrl),
                    radius: 19,
                  ),
                  title: Text(
                    c.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    c.handle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    // Signal navigation (can be triggered from ViewModel)
                    Navigator.pushNamed(context, '/chat', arguments: c);
                  },
                );
              },
            ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
