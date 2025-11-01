import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class AddTweetHeaderWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onPost;
  final bool canPost;
  final bool isLoading;

  const AddTweetHeaderWidget({
    super.key,
    required this.onCancel,
    required this.onPost,
    required this.canPost,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Pallete.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel button
          IconButton(
            onPressed: isLoading ? null : onCancel,
            icon: Icon(
              Icons.close,
              color: isLoading ? Pallete.greyColor : Pallete.whiteColor,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          
          // Post button
          GestureDetector(
            onTap: (canPost && !isLoading) ? onPost : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: (canPost && !isLoading)
                    ? Pallete.borderHover
                    : Pallete.borderHover.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Pallete.whiteColor,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
