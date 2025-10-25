import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/theme.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/models/user_profile.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
void main() {
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,//Theme.of(context).colorScheme.onSurface,
   body: Center(
    child: Column(
      children: [
        SizedBox(height: 10,),
        TweetSummaryWidget(tweetId: 't3'),
        SizedBox(height: 10,),
      ],
    ),
   ),
    );
  }
}
