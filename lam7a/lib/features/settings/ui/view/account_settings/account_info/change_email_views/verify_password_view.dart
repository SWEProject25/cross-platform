import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';
import '../../../../state/change_email_state.dart';
import 'change_email_view.dart';
import 'verify_otp_view.dart';
import 'verify_password_widget.dart';

class VerifyPasswordView extends ConsumerWidget {
  const VerifyPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changeEmailProvider);
    final vm = ref.read(changeEmailProvider.notifier);

    return Scaffold(
      key: const ValueKey("verify_password_page"),
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(Icons.close, size: 28),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              key: const ValueKey("cancel_button"),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const ValueKey("next_or_button"),
              style: FilledButton.styleFrom(
                backgroundColor: state.password.isNotEmpty
                    ? const Color(0xFF1D9BF0)
                    : const Color.fromARGB(151, 29, 156, 240),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 12,
                ),
              ),
              onPressed: state.password.isNotEmpty && !state.isLoading
                  ? () {
                      if (state.currentPage == ChangeEmailPage.verifyPassword) {
                        vm.goToChangeEmail(context);
                      } else if (state.currentPage ==
                          ChangeEmailPage.verifyOtp) {
                        vm.validateOtp(context);
                      } else {
                        vm.goToOtpVerification(context);
                      }
                    }
                  : null,
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      state.currentPage == ChangeEmailPage.verifyOtp
                          ? 'Verify'
                          : 'Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),

      // ✅ Body + Loader
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
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
