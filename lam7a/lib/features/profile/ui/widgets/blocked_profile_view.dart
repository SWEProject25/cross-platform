import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class BlockedProfileView extends ConsumerWidget {
  final String username;
  final int userId;
  final VoidCallback onUnblock;

  const BlockedProfileView({
    super.key,
    required this.username,
    required this.userId,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(profileRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),

              Text(
                "You blocked @$username",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),
              const Text(
                "You can't follow or see their posts.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () async {
                  await repo.unblockUser(userId);
                  onUnblock();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Unblock"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
