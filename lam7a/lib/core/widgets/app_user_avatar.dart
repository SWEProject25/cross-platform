import 'package:flutter/material.dart';

/// Reusable user avatar widget that shows either a network image
/// or the first letter of the display name / username as a fallback.
class AppUserAvatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final String? displayName;
  final String? username;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const AppUserAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.displayName,
    this.username,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final bgColor = backgroundColor ?? Colors.grey[700];
    final initial = _computeInitial(displayName, username);

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: hasImage
          ? null
          : Text(
              initial,
              style: textStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: radius, // reasonable default
                    fontWeight: FontWeight.bold,
                  ),
            ),
    );
  }

  String _computeInitial(String? displayName, String? username) {
    final name = (displayName ?? '').trim();
    if (name.isNotEmpty) {
      return name.characters.first.toUpperCase();
    }
    final user = (username ?? '').trim();
    if (user.isNotEmpty) {
      return user.characters.first.toUpperCase();
    }
    return '?';
  }
}
