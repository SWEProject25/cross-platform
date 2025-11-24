import 'package:flutter/material.dart';

class ProfileNotificationsSheet extends StatefulWidget {
  final String username;
  const ProfileNotificationsSheet({super.key, required this.username});

  @override
  State<ProfileNotificationsSheet> createState() => _ProfileNotificationsSheetState();
}

class _ProfileNotificationsSheetState extends State<ProfileNotificationsSheet> {
  String _value = 'off';

  @override
  Widget build(BuildContext context) {
    final options = {
      'all': 'All Posts',
      'posts_replies': 'All Posts & Replies',
      'live': 'Only live video',
      'off': 'Off',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Wrap(
          children: [
            Center(child: Container(height: 4, width: 48, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
            Text("Don't miss a thing", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('@${widget.username}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ...options.entries.map((e) {
              final key = e.key;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: key == 'all'
                    ? const Text('Get notifications for all of this account’s Posts.')
                    : key == 'posts_replies'
                        ? const Text('Get notifications for this account’s Posts & replies.')
                        : key == 'live'
                            ? const Text('Get notifications only for live broadcasts.')
                            : const Text('Turn off notifications for this account’s Posts.'),
                trailing: Radio<String>(
                  value: key,
                  groupValue: _value,
                  onChanged: (v) => setState(() => _value = v ?? 'off'),
                ),
                onTap: () => setState(() => _value = key),
              );
            }).toList(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_value);
              },
              child: const Text('Done'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
