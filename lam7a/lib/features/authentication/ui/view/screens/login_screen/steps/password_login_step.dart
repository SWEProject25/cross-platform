import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';

class PasswordLogin extends StatelessWidget {
  const PasswordLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 9,
                  child: Text(
                    "Enter your password",
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextInputField(
              key: ValueKey("emailLoginTextField"),
              labelTextField: "",
              isLimited: false,
              flex: 12,
              textType: TextInputType.text,
              onChangeEffect: () {},
              isValid: true,
              content: state.identifier,
              enabled: false,
            ),
            TextInputField(
              key: ValueKey("passwordLoginTextField"),
              labelTextField: "password",
              isLimited: false,
              flex: 12,
              textType: TextInputType.visiblePassword,
              isPassword: true,
              onChangeEffect: viewmodel.updatePasswordLogin,
              isValid: true,
              isLoginField: true,
            ),
          ],
        );
      },
    );
  }
}
