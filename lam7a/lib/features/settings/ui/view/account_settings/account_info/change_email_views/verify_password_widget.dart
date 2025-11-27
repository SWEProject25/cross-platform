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
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();

    passwordController.addListener(() {
      ref
          .read(changeEmailProvider.notifier)
          .updatePassword(passwordController.text);
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'Verify your password',
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
            'Re-enter your X password to continue.',
            style: TextStyle(
              fontSize: 16,
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF53636E)
                  : const Color(0xFF8B98A5),
            ),
          ),
          const SizedBox(height: 20),

          StatefulBuilder(
            builder: (context, setInnerState) {
              passwordFocusNode.addListener(() {
                setInnerState(() {});
              });
              final hasFocus = passwordFocusNode.hasFocus;
              return TextFormField(
                key: const ValueKey("verify_password_textfield"),
                controller: passwordController,
                focusNode: passwordFocusNode,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFF4A90E2)
                          : const Color(0xFF6799FF),
                      width: 2,
                    ),
                  ),
                  labelText: hasFocus ? "Password" : null,
                  hintText: hasFocus ? "" : "Password",
                  border: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
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
