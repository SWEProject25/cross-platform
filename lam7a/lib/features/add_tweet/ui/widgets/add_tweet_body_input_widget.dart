import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class AddTweetBodyInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final int maxLength;

  const AddTweetBodyInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      minLines: 5,
      maxLength: maxLength,
      style: const TextStyle(
        color: Pallete.whiteColor,
        fontSize: 18,
      ),
      decoration: const InputDecoration(
        hintText: "What's happening?",
        hintStyle: TextStyle(
          color: Pallete.greyColor,
          fontSize: 18,
        ),
        border: InputBorder.none,
        counterText: '', // Hide the default counter
        filled: false, // Ensure no fill
        fillColor: Colors.transparent, // Transparent background
      ),
      cursorColor: Pallete.borderHover,
    );
  }
}
