import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class VerificationCode extends StatelessWidget {
  const VerificationCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ////////////////////////////////////////////////////////////////
        ///             the needed state managers                     //
        ////////////////////////////////////////////////////////////////
        final state = ref.watch(authenticationViewmodelProvider);
        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);
        ////////////////////////////////////////////////////////////////
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 9,
                  child: const Text(
                    otpCodeHeaderText,
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
                    otpCodeDesText,
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
                    otpCodeResendText,
                    style: TextStyle(color: Pallete.borderHover),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
