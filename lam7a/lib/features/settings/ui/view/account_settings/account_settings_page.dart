import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/settings_listTile.dart';
import 'account_info/Account_information_page.dart';
import 'change_password/change_password_view.dart';
import 'Deactivate_account/deactivate_account_view.dart';
import '../../viewmodel/account_viewmodel.dart';

class YourAccountSettings extends ConsumerWidget {
  const YourAccountSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.textTheme.titleLarge!.color,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Text(
              state.handle,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.textTheme.bodySmall!.color,
                fontSize: 16,
              ),
            ),
          ],
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
                'See information about your account, download an archive of your data or learn about your account deactivation options.',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.textTheme.bodySmall!.color,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SettingsOptionTile(
              icon: Icons.person_outline_rounded,
              title: 'Account information',
              subtitle:
                  'See your account information like your phone number and email address.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const AccountInformationPage(),
                  ),
                );
              },
            ),
            SettingsOptionTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change your password',
              subtitle: 'Change your password at any time.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const ChangePasswordView(),
                  ),
                );
              },
            ),

            SettingsOptionTile(
              icon: Icons.favorite_border_rounded,
              title: 'Deactivate Account',
              subtitle: 'Find out how you can deactivate your account.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const DeactivateAccountView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
