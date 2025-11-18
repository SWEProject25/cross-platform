import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/ui/widgets/message_tile.dart';

class MessagesListView extends StatefulWidget {
  final List<ChatMessage> messages;
  final Widget? leading;

  final Function()? loadMore;

  const MessagesListView({
    super.key,
    required this.messages,
    this.leading,
    this.loadMore,
  });

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      const double threshold = 200.0; // how close to top to trigger (px)

      // For reversed ListView, top visually = scrollExtent
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - threshold) {
        widget.loadMore?.call();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true, 
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        index = widget.messages.length - 1 - index; 
        final message = widget.messages[index];
        final previousMessage = index > 0 ? widget.messages[index - 1] : null;
        final nextMessage = index < widget.messages.length - 1
            ? widget.messages[index + 1]
            : null;

        final bool showDate =
            previousMessage == null ||
            !_isSameDay(message.time, previousMessage.time);

        final bool showTime =
            nextMessage == null ||
            nextMessage.isMine != message.isMine ||
            !_isSameMinute(message.time, nextMessage.time);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index == 0) widget.leading ?? SizedBox.shrink(),

            if (showDate) ...[_DateSeparator(date: message.time)],
            MessageTile(
              text: message.text,
              isMine: message.isMine,
              timeText: showTime
                  ? DateFormat('h:mm a').format(message.time)
                  : null,
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameMinute(DateTime a, DateTime b) {
    return a.difference(b).inMinutes == 0;
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final text = DateFormat('MMMM d, yyyy').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
      ),
    );
  }
}
