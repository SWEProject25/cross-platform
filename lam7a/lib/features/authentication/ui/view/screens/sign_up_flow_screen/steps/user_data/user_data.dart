import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';

class UserDataSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserDataSignUp();
  }
}

class _UserDataSignUp extends State {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);

        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);


        return Container(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Pallete.blackColor,
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextInputField(
                labelTextField: "Name",
                isLimited: true,
                flex: 8,
                textType: TextInputType.name,
                onChangeEffect: viewModel.updateName,
                isValid: state.isValidName,
              ),
              TextInputField(
                labelTextField: "Email",
                flex: 8,
                textType: TextInputType.emailAddress,
                onChangeEffect: viewModel.updateEmail,
                isValid: state.isValidEmail,
              ),
              TextInputField(
                labelTextField: "Date picker",
                        flex: 8,
                textType: TextInputType.datetime,
                onChangeEffect: viewModel.updateDateTime,
                isValid: true,
                isDate: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
