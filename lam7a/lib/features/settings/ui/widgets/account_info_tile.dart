import 'package:flutter/material.dart';

class AccountInfoTile extends StatelessWidget {
  final String? title;
  final String? value;
  final VoidCallback? onTap;

  const AccountInfoTile({super.key, this.title, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: theme.brightness == Brightness.light
              ? const Color(0xFF0F1317)
              : Color.fromARGB(208, 220, 222, 223),
        ),
      ),
      subtitle: Text(
        value ?? '',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 14,
          color: theme.brightness == Brightness.light
              ? const Color(0xFF53636E)
              : const Color(0xFF8B98A5),
        ),
      ),
      onTap: onTap,
    );
  }
}
