import 'package:flutter/material.dart';

class SettingsSearchBar extends StatelessWidget {
  const SettingsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: isDark ? const Color(0xFF202328) : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            // Handle tap (open search page, etc.)
          },
          splashColor: isDark
              ? const Color.fromARGB(178, 0, 0, 0)
              : Colors.black12,
          highlightColor: isDark
              ? const Color.fromARGB(162, 5, 5, 5)
              : Colors.black26,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.search,
                  color: isDark
                      ? const Color(0xFF75787F)
                      : const Color(0xFF53636E),
                ),
                const SizedBox(width: 8),
                Text(
                  "Search settings",
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF75787F)
                        : const Color(0xFF53636E),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
