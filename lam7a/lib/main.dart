import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/theme.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';

void main() {
  // TO TEST ADD TWEET SCREEN ONLY: Uncomment line below
  // runApp(ProviderScope(child: TestAddTweetApp()));
  
  // TO TEST HOME WITH FAB: Uncomment line below
  runApp(ProviderScope(child: TestTweetHomeApp()));
  
  // NORMAL APP FLOW:
  // runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lam7a',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routes: {
        FirstTimeScreen.routeName : (context) => FirstTimeScreen(),
        SignUpFlow.routeName : (context) => SignUpFlow(), 
        LogInScreen.routeName : (context) => LogInScreen(),
      },
      initialRoute: FirstTimeScreen.routeName,
    );
  }
}
class TestTweetApp extends StatelessWidget {
  const TestTweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Tweet Widget')),
        body: Center(
          child: TweetSummaryWidget(tweetId: 't3'), // 👈 your test widget
        ),
      ),
    );
  }
}

/// Test app for AddTweetScreen
class TestAddTweetApp extends StatelessWidget {
  const TestAddTweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AddTweetScreen(
        userId: 'test_user_123',
      ),
    );
  }
}

/// Test app for TweetHomeScreen with FAB
class TestTweetHomeApp extends StatelessWidget {
  const TestTweetHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TweetHomeScreen(),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
