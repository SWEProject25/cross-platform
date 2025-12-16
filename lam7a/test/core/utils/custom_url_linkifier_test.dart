import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lam7a/core/utils/custom_url_linkifier.dart';

void main() {
  group('DomainLinkifier', () {
    late DomainLinkifier linkifier;

    setUp(() {
      linkifier =  DomainLinkifier();
    });

    test('should pass through non-TextElement elements', () {
      final elements = [
        UrlElement('https://example.com', 'example.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 1);
      expect(result[0], isA<UrlElement>());
    });

    test('should return TextElement unchanged when no matches found', () {
      final elements = [
        TextElement('Just plain text without any URLs'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 1);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Just plain text without any URLs');
    });

    test('should linkify domain with https protocol', () {
      final elements = [
         TextElement('Check out https://google.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 2);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Check out ');
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'https://google.com');
    });

    test('should linkify domain without protocol and prepend https', () {
      final elements = [
         TextElement('Visit google.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 2);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Visit ');
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'https://google.com');
      expect((result[1] as UrlElement).text, 'google.com');
    });

    test('should linkify domain with www', () {
      final elements = [
         TextElement('Go to www.example.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 2);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Go to ');
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'https://www.example.com');
    });

    test('should linkify domain with path', () {
      final elements = [
         TextElement('Check flutter.dev/docs'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 2);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Check ');
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'https://flutter.dev/docs');
    });

    test('should handle multiple URLs in text', () {
      final elements = [
         TextElement('Visit google.com or example.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 4);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Visit ');
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'https://google.com');
      expect(result[2], isA<TextElement>());
      expect((result[2] as TextElement).text, ' or ');
      expect(result[3], isA<UrlElement>());
      expect((result[3] as UrlElement).url, 'https://example.com');
    });

    test('should handle trailing text after URL', () {
      final elements = [
         TextElement('Visit google.com now'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 3);
      expect(result[0], isA<TextElement>());
      expect((result[0] as TextElement).text, 'Visit ');
      expect(result[1], isA<UrlElement>());
      expect(result[2], isA<TextElement>());
      expect((result[2] as TextElement).text, ' now');
    });

    test('should handle URL with http protocol', () {
      final elements = [
         TextElement('Visit http://example.com'),
      ];
      final options =  LinkifyOptions();

      final result = linkifier.parse(elements, options);

      expect(result.length, 2);
      expect(result[1], isA<UrlElement>());
      expect((result[1] as UrlElement).url, 'http://example.com');
    });
  });
}
