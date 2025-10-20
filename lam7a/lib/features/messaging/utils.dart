import 'package:intl/intl.dart';

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
