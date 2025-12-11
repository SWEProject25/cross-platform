import 'package:flutter/material.dart';
import '../view/search_and_auto_complete/search_page.dart';

class SearchAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppbar({super.key, required this.width, required this.hintText});

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
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              size: 26,
            ),
            onPressed: () {
              int count = 0;
              Navigator.popUntil(context, (route) => count++ >= 2);
            },
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchMainPage(initialQuery: hintText),
                  ),
                );
              },
              child: Container(
                height: 38,
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
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
                        : const Color(0xFF7c8289),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: width * 0.04),

          IconButton(
            padding: const EdgeInsets.only(top: 4),
            iconSize: width * 0.06,
            icon: Icon(
              Icons.settings_outlined,
              color: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
