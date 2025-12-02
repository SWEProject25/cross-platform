import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget that renders tweet text with styled hashtags and mentions
class StyledTweetText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final void Function(String username)? onMentionTap;
  final TextStyle? style;

  const StyledTweetText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.maxLines,
    this.overflow,
    this.onMentionTap,
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
    
    // Regex to match hashtags (#word) and mentions (@word)
    final RegExp pattern = RegExp(r'(#\w+|@\w+)');
    
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

      // Add hashtag or mention with grey color and optional tap for mentions
      spans.add(
        TextSpan(
          text: matchedText,
          style: baseStyle.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          recognizer: isMention && onMentionTap != null
              ? (TapGestureRecognizer()
                ..onTap = () {
                  final handle = matchedText.substring(1);
                  if (handle.isNotEmpty) {
                    onMentionTap!(handle);
                  }
                })
              : null,
        ),
      );
      
      lastMatchEnd = match.end;
    }
    
    // Add remaining regular text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ));
    }
    
    return spans;
  }
}
