import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:lam7a/core/utils/custom_url_linkifier.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  const ClickableText(this.text, {super.key, this.style, this.maxLines, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: text,
      onOpen: (link) async {
        FlutterWebBrowser.openWebPage(
          url: link.url,
          customTabsOptions: const CustomTabsOptions(
            colorScheme: CustomTabsColorScheme.dark,
          ),
        );
      },
      linkifiers: const [
        UrlLinkifier(), // keep default URL detection
        DomainLinkifier(), // add custom domain detection
      ],
      overflow: overflow,
      maxLines: maxLines,
      style: style ?? const TextStyle(fontSize: 16),
      linkStyle: (style ?? const TextStyle(fontSize: 16)).copyWith(
        // color: Colors.blue,
        decoration: TextDecoration.underline,
        decorationColor: style?.color ?? Colors.white,
      ),
    );
  }
}
