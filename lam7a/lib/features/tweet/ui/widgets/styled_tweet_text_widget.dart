import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Widget that renders tweet text with styled hashtags and mentions
class StyledTweetText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int? maxLines;
  final TextOverflow? overflow;

  const StyledTweetText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: true,
      text: TextSpan(
        children: _parseText(text, context),
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.onSurface,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  /// Parse text and return list of TextSpans with appropriate styling
  List<TextSpan> _parseText(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    
    // Regex to match hashtags (#word) and mentions (@word)
    final RegExp pattern = RegExp(r'(#\w+|@\w+)');
    
    int lastMatchEnd = 0;
    
    for (final match in pattern.allMatches(text)) {
      // Add regular text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ));
      }
      
      // Add hashtag or mention with grey color
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ));
      
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
