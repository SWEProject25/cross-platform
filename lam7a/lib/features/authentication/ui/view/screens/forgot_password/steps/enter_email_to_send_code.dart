import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';

class EnterEmailToSendCode extends StatelessWidget {
  const EnterEmailToSendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(forgotPasswordViewmodelProvider);
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 12,
                  child: Text(
                    "Find Your lam7a account",
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),

        Row(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 12,
              child: const Text(
                "Enter the email associated to your account to change your password",
                style: TextStyle(color: Pallete.subtitleText),
              ),
            ),
          ],
        ),
            SizedBox(height: 20),
            TextInputField(
              key: ValueKey("emailForForgotPassword"),
              labelTextField: "your email",
              isLimited: false,
              flex: 12,
              textType: TextInputType.emailAddress,
              onChangeEffect: ref.read(forgotPasswordViewmodelProvider.notifier).updateEmail,
              isValid: state.isValidEmail,
              content: state.email,
              enabled: true,
            ),
          ],
        );
      },
    );
  }
}
