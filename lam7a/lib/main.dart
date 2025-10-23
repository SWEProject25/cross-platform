import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/theme.dart';

import 'package:lam7a/features/models/tweet.dart';
import 'package:lam7a/features/tweet_summary/models/user_profile.dart';
import 'package:lam7a/features/tweet_summary/ui/view/widgets/tweet.dart';
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
    final postDate = DateTime.now().subtract(const Duration(days: 1));
    //dummy for Tweet_design fell free to remove when integrating :)
    final post=TweetModel(id:"1",userId: "1",body: "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can’t control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    mediaPic:'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
    mediaVideo: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    date: postDate, likes: 999,comments: 8900,views: 5700000 ,repost: 54 , qoutes: 9000000000,bookmarks: 10);
   final user= UserProf(username: "Mazen", hashUserName: "@mazenthe1",id: '1',
    profilePic: "https://tse1.mm.bing.net/th/id/OIP.LaIEJVg54ruohkapUdF8RAHaEy?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3");

    //
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
