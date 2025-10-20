import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_password_terms_text.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';

class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, childe) {
        final state = ref.watch(authenticationViewmodelProvider);

        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 9,
                    child: const Text(
                      "You'll need a password",
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
                      "Make sure it's 8 chracters or more",
                      style: TextStyle(color: Pallete.subtitleText),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextInputField(
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
          ),
        );
      },
    );
  }
}
