import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/providers/theme_provider.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';

class ResetPassword extends ConsumerWidget {
  const ResetPassword({super.key});
  static const String routeName = "reset_password";
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final token = args?['token'] as String?;
    final id = args?['id'] as int?;
    
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppAssets.xIcon,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),

      body: Column(
        children: [
          Center(
            child: Text(
              "Reset Your Password",
              style: GoogleFonts.outfit(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 12,
                child: const Text(
                  "Enter your new password below here",
                  style: TextStyle(color: Pallete.subtitleText),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Reset Password For Email",
              style: GoogleFonts.outfit(fontSize: 15, color: Pallete.greyColor),
            ),
          ),
          Text(
            ref
                .read(forgotPasswordViewmodelProvider.notifier)
                .EncryptEmail(ref.watch(forgotPasswordViewmodelProvider).email),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 20),
          TextInputField(
            key: ValueKey("emailSignupTextField"),
            labelTextField: "New Password",
            flex: 8,
            textType: TextInputType.emailAddress,
            onChangeEffect: ref
                .read(forgotPasswordViewmodelProvider.notifier)
                .updatePassword,
            isValid: ref.watch(forgotPasswordViewmodelProvider).isValidPassword,
            isPassword: true,
            errorText: Validator().validationErrors(
              ref.watch(forgotPasswordViewmodelProvider).password,
            ),
          ),

          TextInputField(
            key: ValueKey("re-pass"),
            labelTextField: "Re-Type password",
            flex: 8,
            textType: TextInputType.text,
            onChangeEffect: ref
                .read(forgotPasswordViewmodelProvider.notifier)
                .updateRePassword,
            isValid: ref
                .watch(forgotPasswordViewmodelProvider)
                .isValidRePassword,
            isPassword: true,
            errorText: !ref.watch(forgotPasswordViewmodelProvider).isValidRePassword ? "the password is not correct" : "",
            ),
          
          
          AuthenticationStepButton(
            key: ValueKey("reset_password_button"),
            enable: true,
            label: "Reset Password",
            bgColor: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.surface,
            onPressedEffect: () async {
              final viewmodel = ref.read(
                forgotPasswordViewmodelProvider.notifier,
              );
              if (token != null && id != null) {
                bool isReset = await viewmodel.resetPassword(token, id);
                if (isReset) {
                  showSuccessDialog(ref, context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(WidgetRef ref, BuildContext context) {
    bool isDark = ref.watch(themeProviderProvider);
    Widget dialog = AlertDialog(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 71, 71, 71)
          : Theme.of(context).colorScheme.surface,
      title: const Text('Password Reseted Successfully'),
      content: const Text('Return back to login with new password'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
            Navigator.pushNamedAndRemoveUntil(
              context,
              LogInScreen.routeName,
              (_) => false,
            );
          },
          child: const Text('Ok'),
        ),
      ],
    );
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }
}
