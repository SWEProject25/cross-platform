import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/account_info_tile.dart';
import 'change_username_view.dart';
import '../../../viewmodel/account_viewmodel.dart';
import 'change_email_views/verify_password_view.dart';

class AccountInformationPage extends ConsumerWidget {
  const AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
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
              state.handle,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.textTheme.bodySmall!.color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Divider(color: theme.dividerColor, height: 1),
          AccountInfoTile(
            title: 'Username',
            value: state.handle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const ChangeUsernameView()),
              );
            },
          ),
          AccountInfoTile(
            title: 'Email',
            value: state.email,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const VerifyPasswordView()),
              );
            },
          ),
          AccountInfoTile(title: 'Country', value: state.country),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    const logoutColor = Color.fromARGB(255, 255, 19, 19);

    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: implement log out
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
      // Disable the tile’s default splash and tap behavior
      onTap: null,
      enabled: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
    );
  }
}
