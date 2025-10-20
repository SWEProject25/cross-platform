import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';

class UserNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child){
        final state = ref.watch(authenticationViewmodelProvider);

        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);
        return Container(
        child: Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 12,
                  child: const Text(
                    "What should we call you?",
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
                  flex: 12,
                  child: const Text(
                    "your @username is unique. you can always change it later.",
                    style: TextStyle(color: Pallete.subtitleText),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextInputField(
              labelTextField: "Username",
              isLimited: false,
              flex: 12,
              textType: TextInputType.text,
              onChangeEffect: viewModel.updateUserName,
              isValid: state.isValidUsername,
            ),
          ],
        ),
      );
      }
    );
  }
}
