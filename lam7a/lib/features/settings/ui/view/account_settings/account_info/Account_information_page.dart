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
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account information',
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
      body: ListView(
        key: const ValueKey('accountInformationList'),
        children: [
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
              Navigator.of(context).popUntil((route) => route.isFirst);
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
