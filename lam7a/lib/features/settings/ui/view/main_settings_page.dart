import 'package:flutter/material.dart';
import '../widgets/settings_listTile.dart';
import '../widgets/settings_searchBar.dart';

class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'icon': Icons.person_outline,
        'title': 'Your account',
        'subtitle':
            'See information about your account, download an archive of your data or deactivate your account',
      },
      {
        'icon': Icons.lock_outline,
        'title': 'Security and account access',
        'subtitle':
            'Manage your account’s security and keep track of your account’s usage.',
      },
      {
        'icon': Icons.shield_outlined,
        'title': 'Privacy and safety',
        'subtitle': 'Manage what you can see and share on X.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SettingsSearchBar(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final item = options[index];
                return SettingsOptionTile(
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  subtitle: item['subtitle'] as String,
                  onTap: () {
                    // navigate to detailed page later
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
