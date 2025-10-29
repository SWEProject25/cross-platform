import 'package:flutter/material.dart';

class AccountInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const AccountInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(
        value,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.textTheme.bodySmall!.color,
        ),
      ),
      onTap: onTap,
    );
  }
}
