import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/settings_listtile.dart';
import 'account_info/Account_information_page.dart';
import 'change_password/change_password_view.dart';
import '../../viewmodel/account_viewmodel.dart';

class YourAccountSettings extends ConsumerWidget {
  const YourAccountSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(accountProvider);

    print('Account State: $state');

    return Scaffold(
      key: const ValueKey('yourAccountSettingsPage'),

      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.brightness == Brightness.light
                    ? theme.appBarTheme.titleTextStyle!.color
                    : const Color(0xFFE7E9EA),
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Text(
              state.username!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF53636E)
                    : const Color(0xFF8B98A5),
                fontSize: 16,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: theme.brightness == Brightness.light
                ? const Color.fromARGB(120, 83, 99, 110)
                : const Color(0xFF8B98A5),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: ListView(
          key: const ValueKey('yourAccountSettingsList'),

          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'See information about your account, download an archive of your data or learn about your account deactivation options.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.brightness == Brightness.light
                      ? const Color(0xFF53636E)
                      : const Color(0xFF8B98A5),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SettingsOptionTile(
              key: const ValueKey('openAccountInformationTile'),

              icon: Icons.person_outline_rounded,
              title: 'Account information',
              subtitle:
                  'See your account information like your phone number and email address.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AccountInformationPage(
                      key: const ValueKey('accountInformationPage'),
                    ),
                  ),
                );
              },
            ),
            SettingsOptionTile(
              key: const ValueKey('openChangePasswordTile'),
              icon: Icons.lock_outline_rounded,
              title: 'Change your password',
              subtitle: 'Change your password at any time.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const ChangePasswordView(
                      key: ValueKey('changePasswordPage'),
                    ),
                  ),
                );
              },
            ),

            // SettingsOptionTile(
            //   key: const ValueKey('openDeactivateAccountTile'),
            //   icon: Icons.favorite_border_rounded,
            //   title: 'Deactivate Account',
            //   subtitle: 'Find out how you can deactivate your account.',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (ctx) => const DeactivateAccountView(
            //           key: ValueKey('deactivateAccountPage'),
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
