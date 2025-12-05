import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class OauthWebview extends StatelessWidget {
  static const String routeName = "oauth_webview";
  OauthWebview({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final html =
        args?['html'] as String? ??
        "<html><head></head><body>hello world</body></html>";

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppAssets.xIcon,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
      // body: await _launchUrl(url: ServerConstant.serverURL + ServerConstant.apiPrefix + ServerConstant.oAuthGoogleRedirect);
    );
  }

}
