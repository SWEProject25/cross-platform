import 'package:flutter/material.dart';
import '../widgets/settings_listtile.dart';
import '../widgets/settings_search_bar.dart';
import 'account_settings/account_settings_page.dart';
import 'privacy_settings/privacy_settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/account_viewmodel.dart';

class MainSettingsPage extends ConsumerWidget {
  const MainSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(accountProvider);

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
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.brightness == Brightness.light
                    ? theme.appBarTheme.titleTextStyle!.color
                    : const Color(0xFFE7E9EA),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Text(
              state.username!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF53636E)
                    : const Color(0xFF8B98A5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //  SettingsSearchBar(),
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
