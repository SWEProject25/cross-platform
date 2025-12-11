import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/hive_types.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/providers/theme_provider.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/core/theme/theme.dart';
import 'package:lam7a/features/authentication/ui/view/screens/following_screen/following_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/reset_password.dart';
import 'package:lam7a/features/authentication/ui/view/screens/interests_screen/interests_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/oauth_webview/oauth_webview.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/tweet/repository/tweet_updates_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_socket_service.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {

  HiveTypes.initialize();

  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    print("Post Frame Callback: Handling initial message if any.");
    container.read(notificationsReceiverProvider).handleInitialMessageIfAny();
  });

  container.read(notificationsReceiverProvider).initialize();
  await Future.wait([container.read(apiServiceProvider).initialize()]);
  await container.read(authenticationProvider.notifier).isAuthenticated();

  container.listen(socketInitializerProvider, (_, _) => {});
  container.read(messagesSocketServiceProvider).setUpListners();
  container.read(tweetsSocketServiceProvider).setUpListners();
  container.listen(fcmTokenUpdaterProvider, (_, _) => {});

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: OverlaySupport.global(child: MyApp()),
    ),
  );

  // TO TEST ADD TWEET SCREEN ONLY (No auth): Uncomment lines below
  //runApp(ProviderScope(child: TestAddTweetApp()));

  // TO TEST HOME WITH FAB (No auth): Uncomment lines below
  // runApp(ProviderScope(child: TestTweetHomeApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) async {
      debugPrint('onAppLink: $uri');
      String? code = uri.queryParameters['code'];
      String? token = uri.queryParameters['token'];
      final idString = uri.queryParameters['id'];
      int? id = idString != null ? int.tryParse(idString) : null;
      if (code != null) {
        await ref
            .read(authenticationViewmodelProvider.notifier)
            .oAuthGithubLogin(code);
        openAppLink(uri);
      } else if (token != null) {
        // Wait for navigator to be ready, then navigate
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamed(
            ResetPassword.routeName,
            arguments: {'token': token, 'id': id},
          );
        });
      }
    });
  }

  void openAppLink(Uri uri) {
    if (uri.queryParameters.containsKey('code')) {
      final snapshot = ref.watch(authenticationViewmodelProvider);

      // Wait for navigator to be ready before navigating
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!snapshot.hasCompeletedInterestsSignUp) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            InterestsScreen.routeName,
            (_) => false,
          );
        } else if (!snapshot.hasCompeletedFollowingSignUp) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            FollowingScreen.routeName,
            (_) => false,
          );
        } else {
          navigatorKey.currentState?.pushNamed(NavigationHomeScreen.routeName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationProvider);
        print(state.isAuthenticated);
        bool themeState = ref.watch(themeProviderProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'lam7a',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark, // xDarkTheme to test settings
          navigatorKey: navigatorKey,
          themeMode: themeState
              ? ThemeMode.dark
              : ThemeMode.light, //true dark - false light
          routes: {
            FirstTimeScreen.routeName: (context) => FirstTimeScreen(),
            SignUpFlow.routeName: (context) => SignUpFlow(),
            LogInScreen.routeName: (context) => LogInScreen(),
            NavigationHomeScreen.routeName: (context) => NavigationHomeScreen(),
            AuthenticationTransmissionScreen.routeName: (context) =>
                AuthenticationTransmissionScreen(),
            ChatScreen.routeName: (context) => ChatScreen(),
            InterestsScreen.routeName: (context) => InterestsScreen(),
            FollowingScreen.routeName: (context) => FollowingScreen(),
            OauthWebview.routeName: (context) => OauthWebview(),
            ResetPassword.routeName: (context) => ResetPassword(),

            ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
            '/profile': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map;
              final username = args['username'] as String;

              return const ProfileScreen();
            },
            '/tweet': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map;
              final tweetId = args['tweetId'] as String;
              final tweetData = args['tweetData'] as TweetModel?;
              return TweetScreen(tweetId: tweetId, tweetData: tweetData);
            },
          },
          home: !ref.watch(authenticationProvider).isAuthenticated
              ? FirstTimeScreen()
              : NavigationHomeScreen(),
        );
      },
    );
  }
}

class TestTweetApp extends StatelessWidget {
  TestTweetApp({super.key});
  TweetModel tweet = TweetModel(
    id: "t3",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
    authorName: "Mazen",
    authorProfileImage:
        'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
    username: "mazen",
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Tweet Widget')),
        body: Center(
          child: TweetSummaryWidget(
            tweetData: tweet,
            tweetId: 't3',
          ), // 👈 your test widget
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
      home: const AddTweetScreen(userId: 123),
    );
  }
}

/// Test app for TweetHomeScreen with FAB
// class TestTweetHomeApp extends StatelessWidget {
//   const TestTweetHomeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const TweetHomeScreen(),
//     );
//   }
// }

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
