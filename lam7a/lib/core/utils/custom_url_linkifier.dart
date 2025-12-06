import 'package:flutter_linkify/flutter_linkify.dart';

class DomainLinkifier extends Linkifier {
  // Matches:
  // google.com
  // flutter.dev/docs
  // example.co.uk
  static final RegExp domainRegex = RegExp(
    r'((https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\/\S*)?)',
  );

  const DomainLinkifier();

  @override
  List<LinkifyElement> parse(
    List<LinkifyElement> elements,
    LinkifyOptions options,
  ) {
    final List<LinkifyElement> parsedElements = [];

    for (final element in elements) {
      // Only process raw text
      if (element is! TextElement) {
        parsedElements.add(element);
        continue;
      }

      final text = element.text;
      final matches = domainRegex.allMatches(text);

      if (matches.isEmpty) {
        parsedElements.add(TextElement(text));
        continue;
      }

      int lastIndex = 0;

      for (final match in matches) {
        // Add text before match
        if (match.start > lastIndex) {
          parsedElements.add(TextElement(text.substring(lastIndex, match.start)));
        }

        String url = match.group(0)!;

        // Normalize URL (prepend https if missing)
        if (!url.startsWith('http://') &&
            !url.startsWith('https://')) {
          url = 'https://$url';
        }

        parsedElements.add(UrlElement(url, match.group(0)!));

        lastIndex = match.end;
      }

      // Add trailing text
      if (lastIndex < text.length) {
        parsedElements.add(TextElement(text.substring(lastIndex)));
      }
    }

    return parsedElements;
  }
}
