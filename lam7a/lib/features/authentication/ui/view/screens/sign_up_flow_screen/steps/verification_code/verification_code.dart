import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';

class VerificationCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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
                      "We sent you a code",
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
                      "Enter it below to verify emai@example.com",
                      style: TextStyle(color: Pallete.subtitleText),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextInputField(
                labelTextField: "verification code",
                flex: 12,
                textType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                onChangeEffect: viewModel.updateVerificationCode,
                isValid: state.isValidCode,
              ),
              Row(
                children: [
                  SizedBox(width: 40),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Didn't recieve an email?",
                      style: TextStyle(color: Pallete.borderHover),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
