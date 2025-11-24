import 'package:flutter/material.dart';

class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      leading: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(icon, size: 26, color: theme.iconTheme.color),
      ),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(
        subtitle,
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
