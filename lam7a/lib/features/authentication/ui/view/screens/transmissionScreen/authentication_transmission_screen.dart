import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/navigation/view/screens/navigation_home_screen.dart';

class AuthenticationTransmissionScreen extends StatelessWidget {
  static const String routeName = 'transmission';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              ProfilePicture(),
              AuthenticationStepButton(
                label: "Continue",
                enable: true,
                onPressedEffect: () {
                  final authenticationState = ref.watch(authenticationProvider);
                  print(authenticationState.isAuthenticated);
                  if (authenticationState.isAuthenticated) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      NavigationHomeScreen.routeName,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
