import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';

class AddTweetBodyInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final int maxLength;
  final String? authorProfileImage;
  final String? authorName;
  final String? username;
  final FocusNode? focusNode;

  const AddTweetBodyInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.maxLength,
    this.authorProfileImage,
    this.authorName,
    this.username,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User avatar
        AppUserAvatar(
          radius: 20,
          imageUrl: authorProfileImage,
          displayName: authorName,
          username: username,
        ),
        const SizedBox(width: 12),
        
        // Text field
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            maxLines: null,
            minLines: 5,
            maxLength: maxLength,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration:  InputDecoration(
              hintText: "What's happening?",
              hintStyle: Theme.of(context).textTheme.bodyLarge,
              border: InputBorder.none,
              counterText: '', // Hide the default counter
              filled: false, // Ensure no fill
              fillColor: Colors.transparent, // Transparent background
            ),
            cursorColor: Pallete.borderHover,
          ),
        ),
      ],
    );
  }
}
