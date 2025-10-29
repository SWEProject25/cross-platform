import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/change_password_viewmodel.dart';
import '../../../widgets/settings_textfield.dart';
import '../../../viewmodel/account_viewmodel.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordProvider);
    final notifier = ref.read(changePasswordProvider.notifier);
    final username = ref.read(accountProvider).handle;
    final theme = Theme.of(context);
    final blueXColor = const Color(0xFF1D9BF0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          username,
          style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTextField(
              label: 'Current password',
              controller: state.currentController,
              onChanged: notifier.updateCurrent,
              obscureText: true,
              showToggleIcon: true,
            ),
            const SizedBox(height: 20),
            SettingsTextField(
              label: 'New password',
              hint: 'At least 8 characters',
              controller: state.newController,
              focusNode: state.newFocus,
              errorText: state.newPasswordError,
              onChanged: notifier.updateNew,
              obscureText: true,
              showToggleIcon: true,
            ),
            const SizedBox(height: 20),
            SettingsTextField(
              label: 'Confirm password',
              hint: 'At least 8 characters',
              controller: state.confirmController,
              focusNode: state.confirmFocus,
              errorText: state.confirmPasswordError,
              onChanged: notifier.updateConfirm,
              obscureText: true,
              showToggleIcon: true,
            ),
            const SizedBox(height: 40),

            Center(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: state.isValid
                      ? blueXColor
                      : Color.fromARGB(151, 29, 156, 240),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 14,
                  ),
                ),
                onPressed: state.isValid
                    ? () => notifier.validateCurrentPassword(context)
                    : null,
                child: const Text(
                  'Update password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
