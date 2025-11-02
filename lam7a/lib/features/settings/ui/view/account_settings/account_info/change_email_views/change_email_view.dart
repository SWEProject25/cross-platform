import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';
import '../../../../viewmodel/account_viewmodel.dart';

class ChangeEmailView extends ConsumerWidget {
  const ChangeEmailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalState = ref.watch(accountProvider);
    final vm = ref.read(changeEmailProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Text(
            'Change email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Your current email address is ${originalState.email}.\n'
            'What would you like to update it to?',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Email address',
              border: OutlineInputBorder(),
            ),
            onChanged: vm.updateEmail,
          ),
        ],
      ),
    );
  }
}
