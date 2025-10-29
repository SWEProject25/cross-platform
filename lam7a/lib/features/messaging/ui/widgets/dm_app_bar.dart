import 'package:flutter/material.dart';

class DMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final bool showSettings;
  final String title;

  const DMAppBar({
    super.key,
    required this.title,
    this.onProfileTap,
    this.onSettingsTap,
    this.showSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      // backgroundColor: Colors.white,
      // foregroundColor: Colors.black,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage(
              'https://avatar.iran.liara.run/public',
            ),
            child: InkWell(onTap: onProfileTap),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 16.0,
                  ),
                  hintText: 'Search Direct Messages',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  // fillColor: Colors.grey[200],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: ()=>{},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
