import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/muted_users_viewmodel.dart';
import '../../../models/users_model.dart';
import '../../widgets/Status_user_listTile.dart';

class MutedUsersView extends ConsumerWidget {
  const MutedUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mutedUsersProvider);
    final viewModel = ref.read(mutedUsersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Muted Users')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.mutedUsers.isEmpty
          ? _buildEmptyMessage()
          : ListView.builder(
              itemCount: state.mutedUsers.length,
              itemBuilder: (context, index) {
                final user = state.mutedUsers[index];
                return StatusUserTile(
                  user: user,
                  style: Style.muted,
                  onCliked: () => _showUnmuteDialog(context, user, viewModel),
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
              'Mute unwanted users',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'When you mute someone, you won’t see their posts in your feed or receive notifications from them.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showUnmuteDialog(
    BuildContext context,
    User user,
    MutedUsersViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Unmute ${user.displayName}?'),
        content: const Text('They will be able to interact with you again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.unmuteUser(user.id);
              Navigator.pop(context);
            },
            child: const Text('Unmute'),
          ),
        ],
      ),
    );
  }
}
