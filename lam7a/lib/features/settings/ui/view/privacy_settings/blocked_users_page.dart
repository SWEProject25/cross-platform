import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/blocked_users_viewmodel.dart';
import '../../../models/users_model.dart';
import '../../widgets/Status_user_listTile.dart';

class BlockedUsersView extends ConsumerWidget {
  const BlockedUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blockedUsersProvider);
    final viewModel = ref.read(blockedUsersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Users')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.blockedUsers.isEmpty
          ? _buildEmptyMessage()
          : ListView.builder(
              itemCount: state.blockedUsers.length,
              itemBuilder: (context, index) {
                final user = state.blockedUsers[index];
                return StatusUserTile(
                  user: user,
                  style: Style.blocked,
                  onCliked: () => _showUnblockDialog(context, user, viewModel),
                );
              },
            ),
    );
  }

  Widget _buildEmptyMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Block unwanted users',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'When you block someone, they won’t be able to follow or message you, and you won’t receive any notifications from them.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showUnblockDialog(
    BuildContext context,
    User user,
    BlockedUsersViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Unblock ${user.displayName}?'),
        content: const Text('They will be able to interact with you again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.unblockUser(user.id);
              Navigator.pop(context);
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }
}
