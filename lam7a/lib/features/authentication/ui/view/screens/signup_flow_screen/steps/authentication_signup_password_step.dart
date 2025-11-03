import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_password_terms_text.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

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
                  child: const Text(
                    AuthenticationConstants.passwordSignupHeaderText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor,
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
              key: Key("passwordSignupTextField"),
              labelTextField: "password",
              isLimited: false,
              flex: 12,
              textType: TextInputType.visiblePassword,
              isPassword: true,
              onChangeEffect: viewModel.updatePassword,
              isValid: state.isValidSignupPassword,
            ),
            PasswordTermsText(),
          ],
        );
      },
    );
  }
}
