import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/deactivate_account_viewmodel.dart';
import '../../../state/deactivate_account_state.dart';
import 'confirm_deactivate_view.dart';

class DeactivateAccountView extends ConsumerWidget {
  const DeactivateAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deactivateAccountProvider);
    final vm = ref.read(deactivateAccountProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Deactivate your account',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: state.currentPage == DeactivateAccountPage.main
            ? _buildMainPage(context, vm)
            : DeactivateConfirmView(), // <-- new widget file
      ),
    );
  }

  Widget _buildMainPage(BuildContext context, DeactivateAccountViewModel vm) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Profile section
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                // backgroundImage: AssetImage('assets/profile.jpg'),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'mohamed yasser',
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color.fromARGB(210, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 0,
                    ),
                  ),

                  Text(
                    '@mohamed33063545',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Section: This will deactivate your account
          Text(
            'This will deactivate your account',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'You\'re about to start the process of deactivating your X account. '
            'Your display name, @username and public profile will no longer be viewable on X.com, X for iOS or X for Android.',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 28),

          // Section: What else you should know
          Text(
            'What else you should know',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'You can restore your X account if it was accidentally or wrongfully deactivated for up to 30 days after deactivation.',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Some account information may still be available in search engines, such as Google or Bing. ',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: 'Learn More',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF1D9BF0),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'If you just want to change your @username, you don\'t need to deactivate your account — edit it in your settings.',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'To use your current @username or email address with a different X account, ',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: 'change them',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF1D9BF0),
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' before you deactivate this account.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'If you want to download ',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: 'your X data',
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF1D9BF0),
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text:
                      ', you\'ll need to complete both the request and download process before deactivating your account. Links to download your data cannot be sent to deactivated accounts.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          //const Spacer(),
          const SizedBox(height: 14),
          // Bottom Deactivate button
          ListTile(
            contentPadding: EdgeInsets.zero,

            onTap: () {
              vm.goToConfirmPage();
            },
            title: const Center(
              child: Text(
                'Deactivate',
                style: TextStyle(
                  color: Color.fromARGB(255, 247, 42, 42),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
