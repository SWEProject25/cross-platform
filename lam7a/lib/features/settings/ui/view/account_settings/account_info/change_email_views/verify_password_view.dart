import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';
import '../../../../state/change_email_state.dart';
import 'change_email_view.dart';

class VerifyPasswordView extends ConsumerWidget {
  const VerifyPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changeEmailProvider);
    final vm = ref.read(changeEmailProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(Icons.close, size: 28),
        automaticallyImplyLeading: false,
      ),

      // ✅ Floating buttons stay visible above the keyboard
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
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
              onPressed: state.password.isNotEmpty
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

              child: Text(
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

      // ✅ Body content
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: state.currentPage == ChangeEmailPage.verifyPassword
            ? verifyPasswordWidget(context, vm, state)
            : const ChangeEmailView(),
      ),
    );
  }

  Widget verifyPasswordWidget(
    BuildContext context,
    ChangeEmailViewModel vm,
    ChangeEmailState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Text(
            'Verify your password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Re-enter your X password to continue.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
            onChanged: vm.updatePassword,
          ),
        ],
      ),
    );
  }
}
