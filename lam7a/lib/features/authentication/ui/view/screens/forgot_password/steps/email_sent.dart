import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';

class EmailSent extends StatelessWidget {
  const EmailSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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
                      "Continue to reset your password",
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
                "the reset instructions is sent to email",
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
                ref
                    .read(forgotPasswordViewmodelProvider.notifier)
                    .EncryptEmail(
                      ref.read(forgotPasswordViewmodelProvider).email,
                    ),
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Pallete.greyColor,
                ),
              ),
            ),
          
          ],
        );
      },
    );
  }
}
