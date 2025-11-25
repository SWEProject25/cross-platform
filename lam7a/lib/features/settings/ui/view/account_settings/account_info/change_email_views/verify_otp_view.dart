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
  bool _isButtonDisabled = true;
  int _secondsRemaining = 60;
  Timer? _timer;

  void _startCooldown() {
    _timer?.cancel();

    setState(() {
      _isButtonDisabled = true;
      _secondsRemaining = 60;
    });

    // Start a new timer
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
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(changeEmailProvider.notifier);
    final state = ref.watch(changeEmailProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'We sent you a code',
            style: textTheme.titleLarge!.copyWith(
              color: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Text(
            'Please enter the 6-digit code sent to ${state.email}',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF53636E)
                  : const Color(0xFF8B98A5),
            ),
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

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const ValueKey("resend_otp_button"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(bottom: 10),
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _isButtonDisabled
                  ? () {}
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
