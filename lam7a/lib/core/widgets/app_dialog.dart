import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

Future<bool?> showOptionsDialog(
  BuildContext context, {
  required List<String> options,
  required List<VoidCallback> onSelected,
}) {
  ThemeData theme = Theme.of(context);
  return showDialog<bool>(
    context: context,

    builder: (_) => Dialog(
      backgroundColor: Colors.transparent, // important for custom shadows
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 5,
              offset: Offset(0, 10), // vertical shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.asMap().entries.map((entry) {
            int idx = entry.key;
            String option = entry.value;
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              title: Text(option, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16)),
              onTap: () {
                Navigator.pop(context, true);
                onSelected[idx]();
              },
            );
          }).toList(),
        ),
      ),
    ),
  );
}
