import 'package:flutter/material.dart';
import '../view/search_and_auto_complete/search_page.dart';

class Searchbar extends StatelessWidget implements PreferredSizeWidget {
  const Searchbar({super.key, required this.width, required this.hintText});

  final double width;
  final String hintText;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchMainPage()),
                );
              },
              child: Container(
                height: 38,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? const Color(0xFFeff3f4)
                      : const Color(0xFF202328),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF53646e)
                        : const Color(0xFF53595f),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
