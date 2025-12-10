import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String emaiToConfirm = ref.read(forgotPasswordViewmodelProvider).email;
        return Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Where should we send a reset password instructions to?",
                      style: GoogleFonts.outfit(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "WBefore you can change your password we need to make sure it's really you",
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Pallete.greyColor,
                ),
              ),
            ),
            SizedBox(height: 30),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Start by choosing where to send a reset instructions to.",
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Pallete.greyColor,
                ),
              ),
            ),
            RadioGroup<String>(
              groupValue: emaiToConfirm,
              onChanged: (value) {
                emaiToConfirm = value!;
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: emaiToConfirm,
                    autofocus: true,
                    contentPadding: EdgeInsets.all(8),
                    
                    visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                    title: Text(
                      ref
                          .read(forgotPasswordViewmodelProvider.notifier)
                          .EncryptEmail(emaiToConfirm),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
