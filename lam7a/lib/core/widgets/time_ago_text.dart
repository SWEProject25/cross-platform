import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeAgoText extends StatefulWidget {
  final DateTime time;
  final TextStyle? style;

  const TimeAgoText({super.key, required this.time, this.style});

  @override
  State<TimeAgoText> createState() => _TimeAgoTextState();
}

class _TimeAgoTextState extends State<TimeAgoText> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Update every minute
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String timeToTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}d';
    } else if (diff.inDays < 365) {
      return DateFormat('MMM d').format(time);
    } else {
      return DateFormat('MMM yyyy').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeToTimeAgo(widget.time),
      style: widget.style ?? const TextStyle(fontSize: 14),
    );
  }
}
