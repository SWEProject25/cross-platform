import 'package:flutter/material.dart';
import 'package:flutter_typing_indicator/flutter_typing_indicator.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    this.isMine = false,
    this.text = "",
    this.timeText = "",
    this.isRead = false,
    this.isDelivered = true,

    this.showStatus = false,
    this.showTypingIndicator = false,
    this.showFooter = false,
  });


  final bool isMine;
  final String text;
  final String timeText;
  final bool isRead;
  final bool isDelivered;

  final bool showFooter;
  final bool showTypingIndicator;
  final bool showStatus;

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
              borderRadius: !showFooter
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
          if (showFooter)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text( 
                showStatus  && !isDelivered ? "Sending" :
                timeText + (showStatus ? " · ${getStatusText()}" : ""),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  String getStatusText() {
    if (showStatus && isRead) {
      return "Seen";
    }else if (!isDelivered) {
      return "Sending";
    } else if ( isDelivered ) {
      return "Sent";
    } 
    return "";
  }
}
