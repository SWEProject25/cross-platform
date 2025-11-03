import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';
import '../../../../state/change_email_state.dart';
import 'change_email_view.dart';
import 'verify_otp_view.dart';

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
              ChangeEmailPage.verifyPassword => verifyPasswordWidget(
                context,
                vm,
                state,
              ),
              ChangeEmailPage.changeEmail => ChangeEmailView(),
              ChangeEmailPage.verifyOtp => VerifyOtpView(),
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

  Widget verifyPasswordWidget(
    BuildContext context,
    ChangeEmailViewModel vm,
    ChangeEmailState state,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        // 👇 Move the state variable *inside* the builder,
        // so it persists across rebuilds of the parent widget.
        // It will still reset only if this widget itself is rebuilt with a new key.
        bool obscurePassword = true;

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
              StatefulBuilder(
                builder: (context, setInnerState) {
                  return TextField(
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setInnerState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: vm.updatePassword,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
