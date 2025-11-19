import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class UserDataSignUp extends StatefulWidget {
  const UserDataSignUp({super.key});

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
        return Column(
          children: [
            Center(
              child: Text(
                AuthenticationConstants.userDataHeaderText,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 50),
            TextInputField(
              key: ValueKey("nameTextField"),
              content: state.name,
              labelTextField: "Name",
              isLimited: true,
              flex: 8,
              textType: TextInputType.name,
              onChangeEffect: viewModel.updateName,
              isValid: state.isValidName,
            ),
            TextInputField(
              key: ValueKey("emailSignupTextField"),
              content:state.email,
              labelTextField: "Email",
              flex: 8,
              textType: TextInputType.emailAddress,
              onChangeEffect: viewModel.updateEmail,
              isValid: state.isValidEmail,
            ),
            TextInputField(
              key: ValueKey("datePickerTextField"),
              content: state.date,
              labelTextField: "Date picker",
                      flex: 8,
              textType: TextInputType.datetime,
              onChangeEffect: viewModel.updateDateTime,
              isValid: true,
              isDate: true,// make it false for testing purposes
            ),
          ],
        );
      },
    );
  }
}
