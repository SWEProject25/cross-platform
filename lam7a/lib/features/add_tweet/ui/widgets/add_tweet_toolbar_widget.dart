import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class AddTweetToolbarWidget extends StatelessWidget {
  final VoidCallback onImagePick;
  final VoidCallback onGifPick;
  final VoidCallback onPollCreate;

  const AddTweetToolbarWidget({
    super.key,
    required this.onImagePick,
    required this.onGifPick,
    required this.onPollCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Pallete.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Image picker
          _ToolbarButton(
            icon: Icons.image_outlined,
            onTap: onImagePick,
            color: Pallete.borderHover,
          ),
          
          const SizedBox(width: 16),
          
          // Video picker
          _ToolbarButton(
            icon: Icons.videocam_outlined,
            onTap: onGifPick,
            color: Pallete.borderHover,
          ),
          
          const SizedBox(width: 16),
          
          // Poll creator
          _ToolbarButton(
            icon: Icons.poll_outlined,
            onTap: onPollCreate,
            color: Pallete.borderHover,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ToolbarButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}
