import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/forgot_password_screen.dart';
import '../../../viewmodel/change_password_viewmodel.dart';
import '../../../widgets/settings_textfield.dart';
import '../../../viewmodel/account_viewmodel.dart';
import './forget_password_view.dart/send_otp_view.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordProvider);
    final notifier = ref.read(changePasswordProvider.notifier);
    final username = ref.read(accountProvider).username;
    final theme = Theme.of(context);
    final blueXColor = const Color(0xFF1D9BF0);

    return Scaffold(
      key: const Key("change_password_page"),
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: false,
        title: Text(
          username!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.light
                ? const Color(0xFF53636E)
                : const Color(0xFF8B98A5),
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: theme.brightness == Brightness.light
                ? const Color.fromARGB(120, 83, 99, 110)
                : const Color(0xFF8B98A5),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTextField(
              key: const Key("change_password_current_field"),
              label: 'Current password',

              controller: state.currentController,
              onChanged: notifier.updateCurrent,
              obscureText: true,
              showToggleIcon: true,
            ),
            const SizedBox(height: 16),
            SettingsTextField(
              key: const Key("change_password_new_field"),
              label: 'New password',
              hint: 'At least 8 characters',
              controller: state.newController,
              focusNode: state.newFocus,
              validator: (_) => state.newPasswordError,
              onChanged: notifier.updateNew,
              obscureText: true,
              showToggleIcon: true,
            ),
            const SizedBox(height: 16),
            SettingsTextField(
              key: const Key("change_password_confirm_field"),
              label: 'Confirm password',
              hint: 'At least 8 characters',
              controller: state.confirmController,
              focusNode: state.confirmFocus,
              validator: (_) => state.confirmPasswordError,
              onChanged: notifier.updateConfirm,
              obscureText: true,
              showToggleIcon: true,
            ),

            const SizedBox(height: 14),

            Center(
              child: FilledButton(
                key: const Key("change_password_submit_button"),
                style: FilledButton.styleFrom(
                  backgroundColor: state.isValid
                      ? blueXColor
                      : const Color.fromARGB(151, 29, 156, 240),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                onPressed: state.isValid
                    ? () => notifier.changePassword(context)
                    : null,
                child: const Text(
                  'Update password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Center(
              child: TextButton(
                key: const Key("change_password_forgot_button"),
                onPressed: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF53636E)
                        : const Color(0xFF8B98A5),
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
