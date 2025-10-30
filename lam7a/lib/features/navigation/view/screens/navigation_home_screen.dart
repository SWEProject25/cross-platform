import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';

/// Navigation Home Screen - After successful login, users are directed here
/// This screen shows the tweet feed with ability to add tweets
class NavigationHomeScreen extends StatelessWidget {
  static const String routeName = "navigation";
  
  @override
  Widget build(BuildContext context) {
    // After login, show the Tweet Home Screen with feed and add tweet FAB
    return const TweetHomeScreen();
  }
}
