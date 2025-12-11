import 'dart:async';
import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/bin/vmservice_io.dart';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/following_screen/following_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/interests_screen/interests_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_icon_button_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_login_text.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_terms_text.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:lam7a/features/profile/ui/view/followers_following_page.dart';
import 'package:url_launcher/url_launcher.dart';

const String githubRedirectUrl = "hankers://tech.hankers.app";

// first =_time_screen is the screen that appears
//to the user if he opens the application without logging in
class FirstTimeScreen extends ConsumerStatefulWidget {
  static const String routeName = "first_time_screen";
  const FirstTimeScreen({super.key});

  @override
  ConsumerState<FirstTimeScreen> createState() => _FirstTimeScreenState();
}

class _FirstTimeScreenState extends ConsumerState<FirstTimeScreen> {
  StreamSubscription<Uri>? _linkSubscription;
  String? code;
  final _navigatorKey = GlobalKey<NavigatorState>();

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
      code = uri.queryParameters['code'];
      if (code != null) {
        await ref
            .read(authenticationViewmodelProvider.notifier)
            .oAuthGithubLogin(code!);
      }
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    if (uri.queryParameters.containsKey('code')) {
      final snapshot = ref.watch(authenticationViewmodelProvider);
      if (!snapshot.hasCompeletedInterestsSignUp) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          InterestsScreen.routeName,
          (_) => false,
        );
      } else if (!snapshot.hasCompeletedFollowingSignUp) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          FollowingScreen.routeName,
          (_) => false,
        );
      } else {
        Navigator.pushNamed(context, NavigationHomeScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      key: ValueKey("firstScreen"),
      appBar: AppBar(
        title: SvgPicture.asset(
          AppAssets.xIcon,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
          // replaces currentColor
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
          return !isLoading
              ? Column(
                  children: [
                    Spacer(flex: 2),
                    Expanded(
                      flex: 4,
                      //this is the container of the greeting text for the first time opening the application
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(flex: 1),
                            Expanded(
                              flex: 8,
                              child: Text(
                                AuthenticationConstants.firstTimeScreenText,
                                style: GoogleFonts.outfit(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ),

                    // this part concerns in authentication navigation for registration and login and oAuth
                    Column(
                      children: [
                        IconedButtonCentered(
                          key: Key("googleOAuthButton"),
                          buttonLabel:
                              AuthenticationConstants.oAuthWithGoogleText,
                          imgPath: AppAssets.googleIcon,
                          backGroundColor: Pallete.whiteColor,
                          textColor: Pallete.blackColor,
                          isBorder: true,
                          pressEffect: () async {
                            await ref
                                .read(authenticationViewmodelProvider.notifier)
                                .oAuthLoginGoogle();
                            final snapshot = ref.read(
                              authenticationViewmodelProvider,
                            );
                            if (ref
                                .read(authenticationProvider)
                                .isAuthenticated) {
                              if (!snapshot.hasCompeletedInterestsSignUp) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  InterestsScreen.routeName,
                                  (_) => false,
                                );
                              } else if (!snapshot
                                  .hasCompeletedFollowingSignUp) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  FollowingScreen.routeName,
                                  (_) => false,
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  NavigationHomeScreen.routeName,
                                );
                              }
                            }
                          },
                        ),
                        IconedButtonCentered(
                          key: Key("githubOAuthButton"),
                          buttonLabel:
                              AuthenticationConstants.oAuthWithGithubText,
                          imgPath: AppAssets.githubIcon,
                          backGroundColor: Pallete.whiteColor,
                          textColor: Pallete.blackColor,
                          isBorder: true,
                          pressEffect: () async {
                            final Uri authUrl = Uri(
                              scheme: "https",
                              host: ServerConstant.serverURL
                                  .replaceFirst("https://", "")
                                  .replaceFirst("http://", ""),
                              path:
                                  "${ServerConstant.apiPrefix}${ServerConstant.oAuthGithubedirect}",
                              queryParameters: {'platform': 'mobile'},
                            );
                            await _launchUrl(authUrl.toString());
                          },
                        ),
                        const Row(
                          children: [
                            Spacer(flex: 1),
                            Expanded(
                              flex: 2,
                              child: Divider(
                                color: Pallete.inactiveBottomBarItemColor,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                "or",
                                style: TextStyle(color: Pallete.subtitleText),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Divider(
                                color: Pallete.subtitleText,
                                thickness: 1,
                              ),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                        IconedButtonCentered(
                          key: Key("createAccountButton"),
                          buttonLabel: "Create account",
                          backGroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                          textColor: Theme.of(context).colorScheme.surface,
                          pressEffect: () {
                            Navigator.pushNamed(context, SignUpFlow.routeName);
                            viewmodel.changeToSignup();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TermsText(),
                    Spacer(flex: 1),
                    LoginText(
                      // this is the has the login text that moves the user to the log in steps
                      onPress: () {
                        viewmodel.changeToLogin();
                      },
                    ),
                    Spacer(flex: 1),
                  ],
                )
              : Center(child: LoadingCircle());
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }
}
