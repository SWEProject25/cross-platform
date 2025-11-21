import 'package:flutter/material.dart';
import '../view/search_and_auto_complete/recent_searchs_view.dart';

class SearchAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppbar({super.key, required this.width, required this.hintText});

  final double width;
  final String hintText;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            iconSize: width * 0.06,
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),

          SizedBox(width: width * 0.04),

          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecentView()),
                );
              },
              child: Container(
                height: 38,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFF202328),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  hintText,
                  style: const TextStyle(color: Colors.white54, fontSize: 15),
                ),
              ),
            ),
          ),

          SizedBox(width: width * 0.04),

          IconButton(
            padding: const EdgeInsets.only(top: 4),
            iconSize: width * 0.06,
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
