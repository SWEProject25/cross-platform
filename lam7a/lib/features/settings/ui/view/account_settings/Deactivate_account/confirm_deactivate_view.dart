import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/deactivate_account_viewmodel.dart';
import '../../../widgets/settings_textfield.dart';
import '../../../widgets/deactivate_button.dart';

class DeactivateConfirmView extends ConsumerStatefulWidget {
  const DeactivateConfirmView({super.key});

  @override
  ConsumerState<DeactivateConfirmView> createState() =>
      _DeactivateConfirmViewState();
}

class _DeactivateConfirmViewState extends ConsumerState<DeactivateConfirmView> {
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();

    // Listen for text changes and update state through the ViewModel
    passwordController.addListener(() {
      ref
          .read(deactivateAccountProvider.notifier)
          .updatePassword(passwordController.text);
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deactivateAccountProvider);
    final vm = ref.read(deactivateAccountProvider.notifier);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      key: const ValueKey('confirmPage'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.close_rounded, color: Colors.white, size: 48),
          const SizedBox(height: 24),

          Text(
            'Confirm your password',
            style: textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Complete the deactivation request by entering your password associated with your account.',
            style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),

          // Password text field
          SettingsTextField(
            hint: 'Password',
            controller: passwordController,
            obscureText: true,
            showToggleIcon: true,
          ),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: DeactivateButton(
              isActive: state.password.isNotEmpty,
              onPressed: vm.deactivateAccount,
            ),
          ),
        ],
      ),
    );
  }
}
