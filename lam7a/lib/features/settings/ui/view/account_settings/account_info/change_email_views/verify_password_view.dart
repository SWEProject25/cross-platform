import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';
import '../../../../state/change_email_state.dart';
import 'change_email_view.dart';
import 'verify_otp_view.dart';
import 'verify_password_widget.dart';
import 'package:lam7a/core/utils/app_assets.dart';

class VerifyPasswordView extends ConsumerWidget {
  const VerifyPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(changeEmailProvider);
    final vm = ref.read(changeEmailProvider.notifier);

    final bgColor = state.password.isNotEmpty
        ? (theme.brightness == Brightness.light
              ? const Color(0xFF000000)
              : const Color(0xFFeff3f4))
        : (theme.brightness == Brightness.light
              ? const Color.fromARGB(255, 57, 147, 221)
              : const Color.fromARGB(255, 144, 45, 45));

    return Scaffold(
      key: const ValueKey("verify_password_page"),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.xIcon, height: 24),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Divider(color: Colors.grey[300], thickness: 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  key: const ValueKey("cancel_button"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFFBCC9D0)
                          : const Color.fromARGB(255, 200, 200, 200),
                    ),
                  ),

                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 24, 24, 24),
                    ),
                  ),
                ),

                FilledButton(
                  key: const ValueKey("next_or_button"),
                  style: FilledButton.styleFrom(
                    backgroundColor: bgColor,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onPressed: state.password.isNotEmpty && !state.isLoading
                      ? () {
                          if (state.currentPage ==
                              ChangeEmailPage.verifyPassword) {
                            vm.goToChangeEmail(context);
                          } else if (state.currentPage ==
                              ChangeEmailPage.verifyOtp) {
                            vm.validateOtp(context);
                          } else {
                            vm.goToOtpVerification(context);
                          }
                        }
                      : null,
                  child: Text(
                    state.currentPage == ChangeEmailPage.verifyOtp
                        ? 'Verify'
                        : 'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ✅ Body + Loader
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: switch (state.currentPage) {
              ChangeEmailPage.verifyPassword => const VerifyPasswordWidget(
                key: ValueKey("verify_password_widget"),
              ),
              ChangeEmailPage.changeEmail => ChangeEmailView(
                key: const ValueKey("change_email_view"),
              ),
              ChangeEmailPage.verifyOtp => VerifyOtpView(
                key: const ValueKey("verify_otp_view"),
              ),
            },
          ),
          if (state.isLoading)
            Container(
              color: const Color.fromARGB(87, 255, 255, 255),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF1D9BF0)),
              ),
            ),
        ],
      ),
    );
  }
}
