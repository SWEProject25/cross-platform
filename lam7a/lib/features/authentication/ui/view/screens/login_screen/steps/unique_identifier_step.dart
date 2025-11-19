import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';


class UniqueIdentifier extends StatelessWidget
{
  const UniqueIdentifier({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer(
      builder: (context, ref, child)
      {
        final state = ref.watch(authenticationViewmodelProvider.notifier);
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 20,
                  child: const Text(
                    "email",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextInputField(
              key: ValueKey("emailLoginTextField"),
              labelTextField: "Phone, email address or username",
              isLimited: false,
              flex: 12,
              textType: TextInputType.text,
              isValid: true,
              onChangeEffect: state.updateIdentifier,
              isLoginField: true,
            ),
          ],
        );
    });
  }
  
}