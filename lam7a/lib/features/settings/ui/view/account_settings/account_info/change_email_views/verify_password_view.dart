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
    //final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(Icons.close, size: 28), // 🩵 centered X logo
        automaticallyImplyLeading: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: state.currentPage == ChangeEmailPage.verifyPassword
            ? verifyPasswordWidget(context, vm, state)
            : ChangeEmailView(),
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
        children: [
          const SizedBox(height: 80), // top space
          // ✅ Upper half content
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
          ),

          // ✅ Lower buttons fixed at bottom
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
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
                          ? () => vm.goToChangeEmail(context)
                          : null,
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
