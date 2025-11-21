import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/change_email_viewmodel.dart';

class VerifyOtpView extends ConsumerStatefulWidget {
  const VerifyOtpView({super.key});

  @override
  ConsumerState<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends ConsumerState<VerifyOtpView> {
  bool _isButtonDisabled = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  void _startCooldown() {
    setState(() {
      _isButtonDisabled = true;
      _secondsRemaining = 30; // Cooldown duration (seconds)
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _isButtonDisabled = false);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(changeEmailProvider.notifier);
    final state = ref.watch(changeEmailProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Text(
            'We sent you a code',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Text(
            'Please enter the 6-digit code sent to ${state.email}',
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey("otp_textfield"),
            decoration: const InputDecoration(
              hintText: 'Verification code',
              border: OutlineInputBorder(),
            ),
            onChanged: vm.updateOtp,
          ),
          const SizedBox(height: 15),

          // Resend button + cooldown text
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const ValueKey("resend_otp_button"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(bottom: 10), // <-- THIS FIXES THE GAP
                minimumSize: Size(0, 0), // optional: makes it shrink to text
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // optional
              ),
              onPressed: _isButtonDisabled
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          key: const ValueKey("resend_otp_snackbar"),
                          content: Text(
                            'Please wait, available in $_secondsRemaining seconds',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                            ),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  : () async {
                      await vm.ResendOtp();
                      _startCooldown();
                    },
              child: Text(
                'Resend verification code',
                style: TextStyle(
                  fontSize: 13,
                  color: _isButtonDisabled
                      ? Color.fromARGB(138, 29, 156, 240)
                      : Color(0xFF1D9BF0),
                ),
              ),
            ),
          ),

          if (_isButtonDisabled)
            Text(
              key: const ValueKey("resend_otp_cooldown_text"),
              'Available in $_secondsRemaining s',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
