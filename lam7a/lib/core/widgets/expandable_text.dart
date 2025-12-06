import 'package:flutter/material.dart';
import 'package:lam7a/core/widgets/clickable_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText(this.text, {this.trimLines = 3, this.style, super.key});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return LayoutBuilder(
      builder: (context, size) {
        // Build the text with max lines
        final span = TextSpan(text: text);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: size.maxWidth);

        // Check if text exceeds trimLines
        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClickableText(
              text,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: widget.style,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(
                  _isExpanded ? "See less" : "See more",
                  style: widget.style?.copyWith(
                    fontWeight: FontWeight.bold,
                    decorationStyle: TextDecorationStyle.solid
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
