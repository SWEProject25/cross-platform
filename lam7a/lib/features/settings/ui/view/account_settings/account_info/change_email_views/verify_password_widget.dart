import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';

class VerifyPasswordWidget extends ConsumerStatefulWidget {
  const VerifyPasswordWidget({super.key});

  @override
  ConsumerState<VerifyPasswordWidget> createState() =>
      _VerifyPasswordWidgetState();
}

class _VerifyPasswordWidgetState extends ConsumerState<VerifyPasswordWidget> {
  late final TextEditingController passwordController;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();

    // automatically update the ViewModel on text change
    passwordController.addListener(() {
      ref
          .read(changeEmailProvider.notifier)
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
    final state = ref.watch(changeEmailProvider);
    final vm = ref.read(changeEmailProvider.notifier);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),

          // Title
          Text(
            'Verify your password',
            style: textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),

          // Subtext
          Text(
            'Re-enter your X password to continue.',
            style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // 🔑 Password TextField (with your shared widget)
          StatefulBuilder(
            builder: (context, setInnerState) {
              return TextFormField(
                key: const ValueKey("verify_password_textfield"),
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    key: const ValueKey("password_toggle_icon"),
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setInnerState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
