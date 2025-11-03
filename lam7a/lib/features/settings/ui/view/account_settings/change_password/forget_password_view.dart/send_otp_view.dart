import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../viewmodel/account_viewmodel.dart';
import '../../../../viewmodel/forget_password_viewmodel.dart';

class SendOtpView extends ConsumerWidget {
  const SendOtpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgetPasswordProvider);
    final notifier = ref.read(forgetPasswordProvider.notifier);
    //final theme = Theme.of(context);
    final blueXColor = const Color(0xFF1D9BF0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 1️⃣ Header Text
              const Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // 2️⃣ Description Text
              const Text(
                "You will receive a code to verify here so you can reset your account password.",
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
              ),

              const SizedBox(height: 32),

              // 3️⃣ TextField for Code
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your code",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueXColor, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              // 4️⃣ Verify Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: add verify logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueXColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 5️⃣ Info Text
              const Text(
                "If you don't see the email, check other places it might be, like your junk, spam, social, or other folders.",
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
              ),

              const SizedBox(height: 16),

              // 6️⃣ Resend Text Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: resend OTP
                  },
                  child: Text(
                    "Didn't receive your code?",
                    style: TextStyle(
                      color: blueXColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
