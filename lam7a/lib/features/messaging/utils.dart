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

String compressFollowerCount(num count) {
  if (count < 1000) return count.toString();

  const suffixes = ['K', 'M', 'B', 'T'];
  int i = -1;
  double n = count.toDouble();

  while (n >= 1000 && i < suffixes.length - 1) {
    n /= 1000;
    i++;
  }

  // Keep one decimal if needed (e.g. 1.2K), but avoid trailing ".0"
  String value = n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
  return '$value${suffixes[i]}';
}

