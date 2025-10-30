import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';

class MessagesListView extends StatefulWidget {
  final List<ChatMessage> messages;
  final Widget? leading;

  final Function()? loadMore;

  const MessagesListView({super.key, required this.messages, this.leading, this.loadMore});

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
          reverse: true, // 👈 newest messages at bottom
          padding: const EdgeInsets.all(12),
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            index = widget.messages.length - 1 - index; // reverse index for display
            final message = widget.messages[index];
            final previousMessage = index > 0 ? widget.messages[index - 1] : null;
            final nextMessage = index < widget.messages.length - 1 ? widget.messages[index + 1] : null;

            final bool showDate = previousMessage == null ||
                !_isSameDay(message.time, previousMessage.time);

            final bool showTime = nextMessage == null || nextMessage.isMine != message.isMine ||
                !_isSameMinute(message.time, nextMessage.time);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(index == 0)
                  widget.leading ?? SizedBox.shrink(),
                
                if (showDate) ...[
                  _DateSeparator(date: message.time),
                ],
                Align(
                  alignment: message.isMine
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: message.isMine
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: !showTime ? BorderRadius.circular(16) : BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(message.isMine ? 16 : 0),
                        bottomRight: Radius.circular(message.isMine ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      "${message.id}: ${message.text}",
                      style: TextStyle(
                        color: message.isMine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                if (showTime)
                  Align(
                    alignment: message.isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        DateFormat('h:mm a').format(message.time),
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
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
