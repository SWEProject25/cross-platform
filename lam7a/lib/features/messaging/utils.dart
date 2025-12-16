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

