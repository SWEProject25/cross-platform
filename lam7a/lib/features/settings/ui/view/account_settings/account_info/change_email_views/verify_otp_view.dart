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
            decoration: const InputDecoration(
              hintText: 'Verification code',
              border: OutlineInputBorder(),
            ),
            onChanged: vm.updateOtp,
          ),
          const SizedBox(height: 30),

          // Resend button + cooldown text
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: _isButtonDisabled
                      ? () {
                          // Optional: give visual feedback if pressed while disabled
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please wait, available in $_secondsRemaining seconds',
                                style: const TextStyle(color: Colors.white),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      : () async {
                          await vm.ResendOtp();
                          _startCooldown();
                        },
                  child: const Text(
                    'Resend verification code',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1D9BF0)),
                  ),
                ),
                if (_isButtonDisabled)
                  Text(
                    'Available in $_secondsRemaining s',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
