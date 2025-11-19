import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  int _secondsRemaining = 60;
  bool _enableResend = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _enableResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);
        final viewModel = ref.watch(authenticationViewmodelProvider.notifier);
        return Column(
          children: [
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 9,
                  child: const Text(
                    AuthenticationConstants.otpCodeHeaderText,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Pallete.blackColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Spacer(flex: 1),
                Expanded(
                  flex: 9,
                  child: const Text(
                    AuthenticationConstants.otpCodeDesText,
                    style: TextStyle(color: Pallete.subtitleText),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextInputField(
              key: ValueKey("otpCodeTextField"),
              labelTextField: "verification code",
              flex: 12,
              textType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              onChangeEffect: viewModel.updateVerificationCode,
              isValid: state.isValidCode,
            ),
            Row(
              children: [
                SizedBox(width: 40),
                InkWell(
                  onTap: () async {
                    if (_enableResend) {
                      await viewModel.resendOTP();
                      _startCountdown();
                    }
                    else
                    {
                      showToastMessage("there's still  " + _secondsRemaining.toString());
                    }
                  },
                  child: const Text(
                    AuthenticationConstants.otpCodeResendText,
                    style: TextStyle(color: Pallete.borderHover),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
