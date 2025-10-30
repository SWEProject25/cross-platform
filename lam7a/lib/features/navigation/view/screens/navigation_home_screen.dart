import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';

/// Navigation Home Screen - After successful login, users are directed here
/// This screen shows the tweet feed with ability to add tweets
class NavigationHomeScreen extends StatelessWidget {
  static const String routeName = "navigation";

  @override
  Widget build(BuildContext context) {
    // After login, show the Tweet Home Screen with feed and add tweet FAB
    return Scaffold(
      appBar: AppBar(title: Text(AuthenticationConstants.success)),
      body: Consumer(
        builder: (context, ref, child) {
          final authController = ref.watch(authenticationProvider.notifier);
          return Column(
            children: [
              Expanded(child: Container(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  await authController.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    FirstTimeScreen.routeName,
                    (route) => false,
                  );
                },
                child: Text("logout"),
              ),

              ElevatedButton(
                onPressed: () {
                  ref.read(authenticationImplRepositoryProvider).test();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TweetHomeScreen(),
                    ),
                  );
                },
                child: Text("test"),
              ),
            ],
          );
        },
      ),
    );
  }
}
