import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget that renders tweet text with styled hashtags and mentions
class StyledTweetText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final void Function(String username)? onMentionTap;
  final void Function(String hashtag)? onHashtagTap;
  final TextStyle? style;

  const StyledTweetText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.maxLines,
    this.overflow,
    this.onMentionTap,
    this.onHashtagTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: fontSize,
            ) ??
        TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.onSurface,
          decoration: TextDecoration.none,
        );

    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: true,
      text: TextSpan(
        children: _parseText(text, context, defaultStyle),
        style: defaultStyle,
      ),
    );
  }

  /// Parse text and return list of TextSpans with appropriate styling
  List<TextSpan> _parseText(
    String text,
    BuildContext context,
    TextStyle baseStyle,
  ) {
    final List<TextSpan> spans = [];
    
    // Regex to match hashtags (#word) and mentions (@handle), allowing
    // underscores, dots, and hyphens in mentions so usernames like
    // @omar-nabil are fully matched.
    final RegExp pattern = RegExp(r'(#\w+|@[A-Za-z0-9_.-]+)');
    
    int lastMatchEnd = 0;
    
    for (final match in pattern.allMatches(text)) {
      // Add regular text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }
      
      final matchedText = match.group(0) ?? '';
      final isMention = matchedText.startsWith('@');
      final isHashtag = matchedText.startsWith('#');

      GestureRecognizer? recognizer;
      if (isMention && onMentionTap != null) {
        recognizer = TapGestureRecognizer()
          ..onTap = () {
            final handle = matchedText.substring(1);
            if (handle.isNotEmpty) {
              onMentionTap!(handle);
            }
          };
      } else if (isHashtag && onHashtagTap != null) {
        recognizer = TapGestureRecognizer()
          ..onTap = () {
            final tag = matchedText.substring(1);
            if (tag.isNotEmpty) {
              onHashtagTap!(tag);
            }
          };
      }

      // Add hashtag or mention with grey color and optional taps
      spans.add(
        TextSpan(
          text: matchedText,
          style: baseStyle.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
          recognizer: recognizer,
        ),
      );
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining regular text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }
    
    return spans;
  }
}
