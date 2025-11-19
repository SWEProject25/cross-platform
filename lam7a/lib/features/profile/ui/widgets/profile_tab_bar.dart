// lib/features/profile/ui/widgets/profile_tab_bar.dart
import 'package:flutter/material.dart';

class ProfileTabBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const ProfileTabBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Posts',
      'Replies',
      'Highlights',
      'Articles',
      'Media',
      'Likes',
    ];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onTabSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                        color: isSelected ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isSelected)
                      Container(
                        height: 3,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}