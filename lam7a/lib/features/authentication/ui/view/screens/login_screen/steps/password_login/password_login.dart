import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';

class PasswordLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 9,
                    child: const Text(
                      "Enter your password",
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
                labelTextField: "password",
                isLimited: false,
                flex: 12,
                textType: TextInputType.visiblePassword,
                isPassword: true,
                onChangeEffect: () {},
                isValid: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
