import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/theme/theme.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/services/socket_service.dart';
import 'package:lam7a/features/navigation/view/screens/navigation_home_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await Future.wait([
    container.read(apiServiceProvider).initialize(),
  ]);
  await container.read(authenticationProvider.notifier).isAuthenticated();

  container.listen(socketInitializerProvider, (_,_)=>{});
  container.read(messagesSocketServiceProvider).setUpListners();

  runApp(UncontrolledProviderScope(child: MyApp(), container: container));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationProvider);
        print(state.isAuthenticated);

        return MaterialApp(
          title: 'lam7a',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          routes: {
            FirstTimeScreen.routeName: (context) => FirstTimeScreen(),
            SignUpFlow.routeName: (context) => SignUpFlow(),
            LogInScreen.routeName: (context) => LogInScreen(),
            NavigationHomeScreen.routeName: (context) => NavigationHomeScreen(),
            AuthenticationTransmissionScreen.routeName: (context) =>
                AuthenticationTransmissionScreen(),
          },
          home:
              // const Center(child: CircularProgressIndicator(color: Pallete.blackColor, backgroundColor: Pallete.whiteColor,))
              !state.isAuthenticated
              ? FirstTimeScreen()
              : NavigationHomeScreen(),
        );
      },
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
