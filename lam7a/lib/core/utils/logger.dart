import 'package:logger/logger.dart';

import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;

  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level]!;
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;
    final error = event.error;
    final stackTrace = event.stackTrace;

    final buffer = StringBuffer();

    buffer.write('${color('$emoji $className - $message')}');

    if (error != null) {
      buffer.write('\n${color('Error: $error')}');
    }

    if (stackTrace != null) {
      buffer.write('\n${color(stackTrace.toString())}');
    }

    return [buffer.toString()];
  }
}

Logger getLogger(Type type) {
  return Logger(printer: SimpleLogPrinter(type.toString()));
}