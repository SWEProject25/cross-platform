import 'package:flutter/material.dart';
import '../widgets/settings_listtile.dart';
import '../widgets/settings_search_bar.dart';
import 'account_settings/account_settings_page.dart';
import 'privacy_settings/privacy_settings_page.dart';

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
                    if (item['title'] == 'Your account') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const YourAccountSettings(),
                        ),
                      );
                    }
                    // else if (item['title'] == 'Security and account access') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (ctx) => const SecurityAccessPage(),
                    //     ),
                    //   );
                    // }
                    else if (item['title'] == 'Privacy and safety') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const PrivacySettingsPage(),
                        ),
                      );
                    }
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
