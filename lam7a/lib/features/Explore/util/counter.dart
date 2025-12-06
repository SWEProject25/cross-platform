// counter.dart

class CounterFormatter {
  static String format(int number) {
    if (number < 1000) {
      return number.toString();
    }

    // Thousand (k)
    if (number < 1000000) {
      double result = number / 1000;
      return _formatWithSuffix(result, "k");
    }

    // Million (m)
    if (number < 1000000000) {
      double result = number / 1000000;
      return _formatWithSuffix(result, "m");
    }

    // Billion (b)
    double result = number / 1000000000;
    return _formatWithSuffix(result, "b");
  }

  static String _formatWithSuffix(double value, String suffix) {
    // Keep one decimal when needed (like 12.3k)
    String text = value.toStringAsFixed(1);

    // Remove trailing .0
    if (text.endsWith(".0")) {
      text = text.replaceAll(".0", "");
    }

    return "$text$suffix";
  }
}
