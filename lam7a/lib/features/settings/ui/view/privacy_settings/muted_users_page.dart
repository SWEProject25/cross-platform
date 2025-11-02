import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/muted_users_viewmodel.dart';
import '../../widgets/status_user_listtile.dart';
import '../../../../../core/models/user_model.dart';

class MutedUsersView extends ConsumerWidget {
  const MutedUsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mutedUsersProvider);
    final viewModel = ref.read(mutedUsersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Muted Users')),
      body: state.when(
        data: (data) {
          return data.mutedUsers.isEmpty
              ? _buildEmptyMessage()
              : ListView.builder(
                  itemCount: data.mutedUsers.length,
                  itemBuilder: (context, index) {
                    final user = data.mutedUsers[index];
                    return StatusUserTile(
                      user: user,
                      style: Style.muted,
                      onCliked: () =>
                          _showUnmuteDialog(context, user, viewModel),
                    );
                  },
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Something went wrong: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
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
    UserModel user,
    MutedUsersViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Unmute ${user.name!} ?'),
        content: const Text('They will be able to interact with you again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.unmuteUser(user.id!);
              Navigator.pop(context);
            },
            child: const Text('Unmute'),
          ),
        ],
      ),
    );
  }
}
