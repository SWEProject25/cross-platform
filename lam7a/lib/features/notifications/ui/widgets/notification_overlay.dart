import 'package:flutter/material.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';

class TwitterDMNotification extends StatelessWidget {
  final String sender;
  final String message;
  final String avatarUrl;
  final VoidCallback? onTap;

  const TwitterDMNotification({
    required this.sender,
    required this.message,
    required this.avatarUrl,
    this.onTap,
    super.key,
  });

  Color dim(Color c, double amount) {
    return Color.lerp(c, Colors.black, amount)!;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var backColor = theme.brightness == Brightness.dark
        ? dim(theme.colorScheme.primary, 0.8)
        : theme.primaryColorLight;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: backColor, // Twitter DM banner color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),

          child: Container(
            width: double.infinity,
            // margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 12.0,
              bottom: 8.0,
              left: 20.0,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppSvgIcon(
                      AppIcons.filled_message,
                      size: 24,
                      color: theme.primaryColor,
                    ),

                    Positioned(
                      bottom: -16,
                      right: -16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: backColor,
                        child: CircleAvatar(
                          radius: 14 - 2,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),

                /// sender + subtitle + message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: sender,
                              // style: const TextStyle(
                              //   color: Colors.white,
                              //   fontWeight: FontWeight.bold,
                              //   fontSize: 16,
                              // ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " sent you a message",
                              // style: TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 15,
                              // ),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
