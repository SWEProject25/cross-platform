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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        key: const ValueKey("change_email_column"),

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'Change Email',
            key: ValueKey("change_email_title"),
            style: textTheme.titleLarge!.copyWith(
              color: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Your current email address is ${originalState.email}.'
            'What would you like to update it to?',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF53636E)
                  : const Color(0xFF8B98A5),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            key: const ValueKey("change_email_textfield"),
            decoration: InputDecoration(
              hintText: 'Email address',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.brightness == Brightness.light
                      ? const Color(0xFF4A90E2)
                      : const Color(0xFF6799FF),
                  width: 2,
                ),
              ),
            ),
            onChanged: vm.updateEmail,
          ),
        ],
      ),
    );
  }
}
