import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/log_in_nav.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/text_input_field.dart';


class UniqueIdentifier extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return  Consumer(
      builder: (context, ref, child)
      {
        final state = ref.watch(authenticationViewmodelProvider.notifier);
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 20,
                    child: const Text(
                      "To get startred first enter your phone, email address or @username",
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
                labelTextField: "Phone, email address or username",
                isLimited: false,
                flex: 12,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: state.updateIdentifier
              ),
            ],
          )
          );
    });
  }
  
}