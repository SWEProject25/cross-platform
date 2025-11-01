import 'package:flutter/foundation.dart';

/// Debug-only logger. Prints only in debug mode (kDebugMode).
void debugLog(Object? object) {
  if (kDebugMode) {
    // ignore: avoid_print
    print(object);
  }
}
