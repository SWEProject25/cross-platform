import 'package:flutter/material.dart';
import '../../widgets/settings_listtile.dart';
import 'blocked_users_page.dart';
import 'muted_users_page.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Privacy and safety',
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.textTheme.titleLarge!.color,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Manage who can interact with you and control what you see.',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.textTheme.bodySmall!.color,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Muted accounts
            SettingsOptionTile(
              icon: Icons.volume_off_outlined,
              title: 'Muted accounts',
              subtitle:
                  'Review and manage accounts you’ve muted so you don’t see their posts.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const MutedUsersView()),
                );
              },
            ),

            // Blocked accounts
            SettingsOptionTile(
              icon: Icons.block_outlined,
              title: 'Blocked accounts',
              subtitle:
                  'See the accounts you’ve blocked and manage who can contact you.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => const BlockedUsersView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
