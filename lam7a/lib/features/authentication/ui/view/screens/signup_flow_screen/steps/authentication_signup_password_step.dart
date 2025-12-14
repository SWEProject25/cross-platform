import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_password_terms_text.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, childe) {

        final state = ref.watch(authenticationViewmodelProvider);
        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 9,
                  child:  Text(
                    AuthenticationConstants.passwordSignupHeaderText,
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
                  flex: 9,
                  child: const Text(
                    AuthenticationConstants.passwordSignupInstructionsText,
                    style: TextStyle(color: Pallete.subtitleText),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextInputField(
              key: ValueKey("passwordSignupTextField"),
              labelTextField: "password",
              isLimited: false,
              flex: 12,
              textType: TextInputType.visiblePassword,
              isPassword: true,
              onChangeEffect: viewModel.updatePassword,
              isValid: state.isValidSignupPassword,
              errorText: Validator().validationErrors(state.passwordSignup),
            ),
            PasswordTermsText(),
          ],
        );
      },
    );
  }
}
