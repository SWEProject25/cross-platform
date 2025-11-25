import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/account_info_tile.dart';
import 'change_username_view.dart';
import '../../../viewmodel/account_viewmodel.dart';
import 'change_email_views/verify_password_view.dart';
import 'package:lam7a/core/providers/authentication.dart';

class AccountInformationPage extends ConsumerWidget {
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(accountProvider);

    return Scaffold(
      key: const ValueKey('accountInformationPage'),
      appBar: AppBar(
        key: const ValueKey('accountInformationAppBar'),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account information',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.textTheme.titleLarge!.color,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            Text(
              state.username!,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.textTheme.bodySmall!.color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        key: const ValueKey('accountInformationList'),
        children: [
          Divider(color: theme.dividerColor, height: 1),

          AccountInfoTile(
            key: const ValueKey('usernameTile'),
            title: 'Username',
            value: state.username!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ChangeUsernameView(
                    key: ValueKey('changeUsernamePage'),
                  ),
                ),
              );
            },
          ),

          AccountInfoTile(
            key: const ValueKey('emailTile'),
            title: 'Email',
            value: state.email!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const VerifyPasswordView(
                    key: ValueKey('verifyPasswordPage'),
                  ),
                ),
              );
            },
          ),

          AccountInfoTile(
            key: const ValueKey('countryTile'),
            title: 'Country',
            value: state.location ?? "Egypt",
          ),

          _buildLogoutTile(context, ref),
        ],
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context, WidgetRef ref) {
    const logoutColor = Color.fromARGB(255, 255, 19, 19);
    final auth = ref.read(authenticationProvider.notifier);

    return ListTile(
      key: const ValueKey('logoutTile'),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            key: const ValueKey('logoutText'),
            onTap: () {
              auth.logout();
            },
            behavior: HitTestBehavior.translucent,
            child: const Text(
              'Log out',
              style: TextStyle(
                color: logoutColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      onTap: null,
      enabled: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
    );
  }
}
