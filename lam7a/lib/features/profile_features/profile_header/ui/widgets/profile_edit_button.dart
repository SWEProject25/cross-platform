import 'package:flutter/material.dart';

class ProfileEditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileEditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: Colors.grey.shade400),
        backgroundColor: Colors.white,
      ),
      child: const Text(
        'Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
