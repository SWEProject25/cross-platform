import 'package:flutter/material.dart';
import 'package:flutter_typing_indicator/flutter_typing_indicator.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    this.text = "",
    this.isMine = false,
    this.timeText,
    this.showTypingIndicator = false,
  });

  final String text;
  final bool isMine;
  final String? timeText;
  final bool showTypingIndicator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMine ? Colors.blueAccent : Colors.grey.shade300,
              borderRadius: timeText == null && !showTypingIndicator
                  ? BorderRadius.circular(16)
                  : BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 0),
                      bottomRight: Radius.circular(isMine ? 0 : 16),
                    ),
            ),
            child: showTypingIndicator
                ? TypingIndicator(
                    backgroundColor: Colors.transparent,
                    dotColor: Colors.black,
                    dotSize: 4,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: isMine ? Colors.white : Colors.black,
                    ),
                  ),
          ),
          if (timeText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                timeText ?? '',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
